#!/usr/bin/env bash
# Récap journal Obsidian — lancé par cron (50 16 * * 1-5).
# Daily chaque jour ouvré ; le jeudi, weekly à la suite (l'ordre garantit
# que la weekly voit la daily du jour).
#
# Chaque appel à claude est retenté jusqu'à MAX_TRIES fois, avec une pause
# croissante (DELAYS), quand il échoue — code de sortie non nul, sortie vide,
# ou première ligne en « API Error » (529 Overloaded, 5xx…). L'échec de la
# daily ne bloque pas la weekly : les deux récaps sont suivis séparément.
# Un récap dont toutes les tentatives ont échoué est inscrit dans PENDING,
# une ligne « <jour> <daily|weekly> », et rejoué au début de l'exécution
# suivante.
#
# Usage :
#   journal-recap.sh                              jour courant (mode cron)
#   journal-recap.sh --date 2026-09-03            rejoue un jour manqué
#                                                 (weekly incluse si jeudi)
#   journal-recap.sh --date 2026-09-03 --weekly   force la weekly pour ce jour
set -uo pipefail

CLAUDE="$HOME/.local/bin/claude"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude/automation"
PENDING="$DIR/pending.txt"
LOCK="$DIR/.lock"
JOURNAL="$HOME/vault/Journal"
ALLOWED='Read,Glob,Grep,Write,Edit,Bash(git:*),Bash(find:*),Bash(ls:*),Bash(date:*),Bash(head:*),Bash(tail:*),Bash(wc:*),Bash(grep:*)'
MAX_TRIES=5
DELAYS=(120 300 600 900)   # pauses entre tentatives, en secondes (2, 5, 10, 15 min)

cd "$HOME"

# Un rattrapage peut durer des heures (5 tentatives × jusqu'à 15 min de pause).
# Sans verrou, l'exécution du lendemain démarrerait à côté de celle qui traîne
# et les deux se disputeraient PENDING et la même note.
exec 9>"$LOCK"
if ! flock -n 9; then
  echo "=== $(date -Iseconds) — exécution déjà en cours, abandon ==="
  exit 0
fi

# Capturé une fois : un rattrapage long peut franchir minuit, et « aujourd'hui »
# ne doit pas changer en cours de route.
TODAY="$(date +%F)"

# --- arguments ---------------------------------------------------------------
TARGET=""
FORCE_WEEKLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --date)
      [ $# -ge 2 ] || { echo "--date exige une date au format YYYY-MM-DD" >&2; exit 2; }
      TARGET="$2"; shift 2 ;;
    --weekly) FORCE_WEEKLY=1; shift ;;
    *) echo "argument inconnu : $1" >&2; exit 2 ;;
  esac
done

if [ -n "$TARGET" ]; then
  TARGET="$(date -d "$TARGET" +%F 2>/dev/null)" \
    || { echo "date invalide : impossible de lire l'argument de --date" >&2; exit 2; }
fi

# --- chemin de la note produite par un récap ---------------------------------
# Sert à restaurer la note quand une tentative échoue après l'avoir écrite.
note_path() {   # note_path <daily|weekly> <jour>
  local kind="$1" day="$2"
  case "$kind" in
    daily)  printf '%s/Daily/%s/%s/%s.md' \
              "$JOURNAL" "$(date -d "$day" +%Y)" "$(date -d "$day" +%Y-%m)" "$day" ;;
    weekly) printf '%s/Weekly/%s/%s.md' \
              "$JOURNAL" "$(date -d "$day" +%G)" "$(date -d "$day" +%G-W%V)" ;;
  esac
}

# --- prompt d'un récap -------------------------------------------------------
# Les prompts de référence sont écrits pour « aujourd'hui ». Pour un rejeu, on
# les préfixe d'une consigne qui fixe la date et borne les commandes de collecte.
build_prompt() {   # build_prompt <daily|weekly> <jour>
  local kind="$1" day="$2" file next week
  if [ "$kind" = daily ]; then
    file="$DIR/daily-recap-prompt.md"
  else
    file="$DIR/weekly-recap-prompt.md"
  fi

  if [ "$day" = "$TODAY" ]; then
    cat "$file"
    return
  fi

  if [ "$kind" = daily ]; then
    next="$(date -d "$day + 1 day" +%F)"
    cat <<EOF
REJEU D'UNE EXÉCUTION MANQUÉE : le jour à traiter est le $day, pas la date d'aujourd'hui. Partout où le prompt ci-dessous parle du « jour courant » ou d'« aujourd'hui », lis « le $day ». Adapte les commandes de collecte en conséquence : pour git, \`--since="$day 05:00" --until="$next 05:00"\` ; pour find, \`-newermt "$day 00:00" ! -newermt "$next 00:00"\`. La note à écrire est celle du $day.

EOF
  else
    week="$(date -d "$day" +%G-W%V)"
    cat <<EOF
REJEU D'UNE EXÉCUTION MANQUÉE : la semaine à traiter est $week (celle du $day), pas celle d'aujourd'hui. Partout où le prompt ci-dessous parle de la « semaine courante » ou d'« aujourd'hui », lis « $week » et « le $day ». Lis les dailies du lundi de cette semaine jusqu'au $day inclus.

EOF
  fi
  cat "$file"
}

# --- un récap, avec tentatives ----------------------------------------------
# Retourne 0 si une tentative a abouti, 1 sinon.
run_recap() {   # run_recap <daily|weekly> <jour>
  local kind="$1" day="$2"
  local note prompt out snap had_note rc attempt delay
  note="$(note_path "$kind" "$day")"
  prompt="$(build_prompt "$kind" "$day")"
  out="$(mktemp)"; snap="$(mktemp)"

  had_note=0
  if [ -f "$note" ]; then cp "$note" "$snap"; had_note=1; fi

  echo "=== $(date -Iseconds) — récap $kind du $day ==="
  for attempt in $(seq 1 "$MAX_TRIES"); do
    echo "--- $kind $day — tentative $attempt/$MAX_TRIES ($(date -Iseconds))"
    # stdin fermé : sinon claude draine le flux qui alimente la boucle appelante.
    "$CLAUDE" -p "$prompt" --model opus --allowedTools "$ALLOWED" </dev/null 2>&1 | tee "$out"
    rc=${PIPESTATUS[0]}
    # Le motif d'erreur n'est cherché que sur la première ligne : le corps du
    # compte rendu cite couramment des messages d'erreur qui n'en sont pas.
    if [ "$rc" -eq 0 ] && [ -s "$out" ] && ! head -n1 "$out" | grep -qE '^(API Error|Error:)'; then
      rm -f "$out" "$snap"
      return 0
    fi
    echo "--- $kind $day — échec (rc=$rc)"
    # Les prompts complètent la note sans la réécrire. Une tentative morte après
    # avoir écrit laisserait ses lignes en place, et la suivante les doublerait.
    if [ "$had_note" -eq 1 ]; then cp "$snap" "$note"; else rm -f "$note"; fi
    if [ "$attempt" -lt "$MAX_TRIES" ]; then
      delay=${DELAYS[$((attempt - 1))]:-900}
      echo "--- nouvelle tentative dans ${delay}s"
      sleep "$delay"
    fi
  done
  rm -f "$out" "$snap"
  return 1
}

# --- file de travail ---------------------------------------------------------
QUEUE=()
FAILED=()

enqueue() {   # enqueue <jour> <daily|weekly> — sans doublon
  local entry="$1 $2" e
  for e in ${QUEUE[@]+"${QUEUE[@]}"}; do
    [ "$e" = "$entry" ] && return 0
  done
  QUEUE+=("$entry")
}

# PENDING est réécrit après chaque récap : ce qui reste à faire, plus ce qui a
# déjà échoué. Une interruption ne perd donc au pire qu'un récap en cours.
rewrite_pending() {   # rewrite_pending <index du prochain non traité>
  local start="$1" i tmp
  tmp="$(mktemp)"
  for i in ${FAILED[@]+"${!FAILED[@]}"}; do echo "${FAILED[$i]}" >> "$tmp"; done
  for ((i = start; i < ${#QUEUE[@]}; i++)); do echo "${QUEUE[$i]}" >> "$tmp"; done
  if [ -s "$tmp" ]; then mv "$tmp" "$PENDING"; else rm -f "$tmp" "$PENDING"; fi
}

# Le backlog est lu en entier avant de lancer quoi que ce soit : le lire au fil
# de la boucle exposerait le flux aux commandes lancées dedans.
if [ -s "$PENDING" ]; then
  while read -r day kind; do
    [ -n "$day" ] && [ -n "$kind" ] && enqueue "$day" "$kind"
  done < "$PENDING"
fi

day="${TARGET:-$TODAY}"
enqueue "$day" daily
weekly=$FORCE_WEEKLY
[ "$(date -d "$day" +%u)" -eq 4 ] && weekly=1
[ "$weekly" -eq 1 ] && enqueue "$day" weekly

# --- exécution ---------------------------------------------------------------
status=0
for ((idx = 0; idx < ${#QUEUE[@]}; idx++)); do
  set -- ${QUEUE[$idx]}
  if ! run_recap "$2" "$1"; then
    FAILED+=("$1 $2")
    status=1
  fi
  rewrite_pending "$((idx + 1))"
done

if [ "$status" -eq 0 ]; then
  echo "=== $(date -Iseconds) — terminé ==="
else
  echo "=== $(date -Iseconds) — ÉCHEC sur ${#FAILED[@]} récap(s), inscrits dans $PENDING ==="
  for i in ${FAILED[@]+"${!FAILED[@]}"}; do echo "    ${FAILED[$i]}"; done
fi
exit $status
