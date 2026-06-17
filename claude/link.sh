#!/usr/bin/env sh
# Relie ~/.claude aux fichiers versionnés de ~/.config/claude.
# Symlinks au niveau DOSSIER : tout skill/rule/commande ajouté dans la config
# apparaît automatiquement dans ~/.claude après un pull, sans geste par fichier.
# Idempotent : à relancer après un clone/pull sur une nouvelle machine.
set -eu

CFG="$HOME/.config/claude"
ACT="$HOME/.claude"
mkdir -p "$ACT"

link() {
  name="$1"
  src="$CFG/$name"
  dst="$ACT/$name"
  if [ ! -e "$src" ]; then
    echo "skip  $name (absent de la config)"
    return
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok    $name (déjà lié)"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"
    echo "sauv  $name → $(basename "$bak")"
  fi
  ln -s "$src" "$dst"
  echo "lien  $name → $src"
}

# Dossiers entiers + le fichier d'instructions global.
link CLAUDE.md
link rules
link skills
link commands

echo "OK — ~/.claude relié à ~/.config/claude."
