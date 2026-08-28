#!/usr/bin/env bash
# Met une machine à niveau après un clone de ~/.config : ce que le dépôt seul
# ne peut pas porter — plugins tmux, outils compilés, timer, tâche planifiée.
#
# Idempotent : le relancer ne casse rien et ne réinstalle que ce qui manque.
set -uo pipefail

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
SRC="$HOME/src"
declare -a manques=()

info() { printf '  %s\n' "$*"; }
etape() { printf '\n\033[1m%s\033[0m\n' "$*"; }

etape "tmux — gestionnaire de plugins"
TPM="$CONFIG/tmux/plugins/tpm"
if [ -d "$TPM/.git" ]; then
  info "tpm déjà installé"
else
  git clone -q https://github.com/tmux-plugins/tpm "$TPM" && info "tpm cloné"
fi
# Installe les plugins déclarés par `set -g @plugin` dans tmux.conf. Sans
# serveur tmux en marche, le script de tpm sort en erreur sans rien faire.
if [ -x "$TPM/bin/install_plugins" ] && tmux info &>/dev/null; then
  "$TPM/bin/install_plugins" >/dev/null && info "plugins tmux à jour"
else
  info "plugins à installer depuis tmux : prefix + I"
fi

etape "outils compilés"
# Dépôts que la config appelle sans les contenir. Chacun porte son URL ici :
# tant qu'elle est vide, le dépôt n'existe que sur la machine d'origine.
installer_outil() { # <nom> <url> <commande d'installation>
  local nom="$1" url="$2" install="$3"
  local dir="$SRC/$nom"
  if [ ! -d "$dir" ]; then
    if [ -z "$url" ]; then
      manques+=("$nom : aucun dépôt distant — à publier depuis la machine d'origine")
      return
    fi
    mkdir -p "$SRC" && git clone -q "$url" "$dir" || { manques+=("$nom : clone impossible"); return; }
  fi
  ( cd "$dir" && eval "$install" >/dev/null 2>&1 ) \
    && info "$nom installé" \
    || manques+=("$nom : l'installation a échoué (cf. $dir)")
}

SIDECAR_URL=""
REGIE_URL=""
installer_outil sidecar "$SIDECAR_URL" "cargo install --path ."
# regie.nvim est chargé par lazy depuis son dossier : rien à compiler.
installer_outil regie.nvim "$REGIE_URL" "true"

etape "sauvegarde des sessions tmux"
if systemctl --user enable --now tmux-resurrect-save.timer 2>/dev/null; then
  info "timer tmux-resurrect-save actif"
else
  manques+=("timer systemd : systemctl --user enable --now tmux-resurrect-save.timer")
fi

etape "récap du journal"
LIGNE="50 16 * * 1-5 $CONFIG/claude/automation/journal-recap.sh >> $CONFIG/claude/automation/recap.log 2>&1"
if crontab -l 2>/dev/null | grep -qF "journal-recap.sh"; then
  info "tâche cron déjà en place"
else
  { crontab -l 2>/dev/null; echo "$LIGNE"; } | crontab - && info "tâche cron ajoutée"
fi

if [ "${#manques[@]}" -eq 0 ]; then
  printf '\n\033[1mTout est en place.\033[0m\n'
else
  printf '\n\033[1mReste à faire :\033[0m\n'
  printf '  - %s\n' "${manques[@]}"
fi
