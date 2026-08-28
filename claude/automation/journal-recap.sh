#!/usr/bin/env bash
# Récap journal Obsidian — lancé par cron (50 16 * * 1-5).
# Daily chaque jour ouvré ; le jeudi, weekly à la suite (l'ordre garantit
# que la weekly voit la daily du jour).
set -euo pipefail

CLAUDE="$HOME/.local/bin/claude"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude/automation"
ALLOWED='Read,Glob,Grep,Write,Edit,Bash(git:*),Bash(find:*),Bash(ls:*),Bash(date:*),Bash(head:*),Bash(tail:*),Bash(wc:*),Bash(grep:*)'

cd "$HOME"

echo "=== $(date -Iseconds) — récap daily ==="
"$CLAUDE" -p "$(cat "$DIR/daily-recap-prompt.md")" \
  --model opus \
  --allowedTools "$ALLOWED"

if [ "$(date +%u)" -eq 4 ]; then
  echo "=== $(date -Iseconds) — récap weekly (jeudi) ==="
  "$CLAUDE" -p "$(cat "$DIR/weekly-recap-prompt.md")" \
    --model opus \
    --allowedTools "$ALLOWED"
fi

echo "=== $(date -Iseconds) — terminé ==="
