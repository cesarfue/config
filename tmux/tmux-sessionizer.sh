#!/usr/bin/env bash
# Sessionizer : sessions tmux par projet de ~/src, avec sujets multiples par repo.
#
# La liste fzf contient les sessions tmux existantes puis les dossiers de ~/src.
# - Sélectionner une entrée : rattache la session, ou la crée dans le dossier.
# - Taper un nom absent de la liste sous la forme <repo>/<sujet> puis Entrée :
#   crée une session "repo/sujet" dont le cwd est ~/src/<repo>.
# Le popup est modal, façon vim :
# - mode insertion (au démarrage) : on tape pour filtrer ou nommer un sujet ;
# - Échap passe en mode normal : j/k pour se déplacer, x tue la session
#   surlignée (sans effet sur un dossier sans session), q quitte, i revient
#   en insertion. Entrée ouvre dans les deux modes.
set -euo pipefail

SRC="$HOME/src"

list() {
    # Sessions existantes d'abord (sujets inclus), puis dossiers par date de modif.
    tmux list-sessions -F '#{session_name}' 2>/dev/null || true
    ls -dt "$SRC"/*/ | xargs -n1 basename
}

# Rappelé par le reload fzf après un Ctrl-x.
if [ "${1:-}" = "--list" ]; then
    list | awk '!seen[$0]++'
    exit 0
fi

# --print-query : la 1re ligne de sortie est ce qui a été tapé, la 2e la
# sélection s'il y en a une. fzf sort en code 1 quand rien ne matche — c'est
# le cas "nouveau sujet", donc on ne le traite pas comme une erreur.
# Modal : les touches vim (j/k/x/i/q) ne sont liées qu'en mode normal —
# unbind au démarrage (insertion), rebind sur Échap, re-unbind sur i.
out=$(list | awk '!seen[$0]++' | fzf --prompt='projet > ' --print-query \
    --header='échap : mode normal (j/k · x : tuer · q : quitter · i : insertion)' \
    --bind 'start:unbind(j,k,x,i,q)' \
    --bind 'esc:disable-search+rebind(j,k,x,i,q)+change-prompt(-- NORMAL -- > )' \
    --bind 'i:enable-search+unbind(j,k,x,i,q)+change-prompt(projet > )' \
    --bind 'j:down' \
    --bind 'k:up' \
    --bind 'q:abort' \
    --bind "x:execute-silent(tmux kill-session -t ={})+reload($0 --list)") || true
query=$(sed -n 1p <<<"$out")
sel=$(sed -n 2p <<<"$out")
target=${sel:-$query}
[ -z "$target" ] && exit 0

# tmux interdit '.' et ':' dans les noms de session.
name=$(tr '.:' '__' <<<"$target")

# '=' impose une correspondance exacte (sinon tmux matche par préfixe,
# et "accoreboot" attraperait "accoreboot-infra").
if ! tmux has-session -t "=$name" 2>/dev/null; then
    repo=${target%%/*}
    dir="$SRC/$repo"
    if [ ! -d "$dir" ]; then
        echo "pas de dossier $dir" >&2
        read -r -n1 -p "(une touche pour fermer)"
        exit 1
    fi
    tmux new-session -ds "$name" -c "$dir"
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "=$name"
else
    tmux attach-session -t "=$name"
fi
