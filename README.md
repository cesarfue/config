# Configuration

Dépôt cloné directement en `~/.config`.

## Sur une machine neuve

```bash
git clone git@github-perso:cesarfue/config.git ~/.config
~/.config/bootstrap.sh
```

`bootstrap.sh` installe ce que le dépôt ne peut pas porter : TPM et les plugins
tmux, les outils compilés depuis `~/src`, le timer de sauvegarde des sessions
et la tâche cron du récap. Il est idempotent — le relancer après un `git pull`
ne réinstalle que ce qui manque, et il liste en fin d'exécution ce qui demande
une intervention.

## Ce que le dépôt ne contient pas

Les plugins tmux ne sont pas versionnés : TPM les installe à partir des
`set -g @plugin` de `tmux/tmux.conf`.

Les outils appelés par la configuration vivent dans leurs propres dépôts, dont
`bootstrap.sh` porte les URL en tête de la section « outils compilés » :

| Outil | Appelé par | Rôle |
|---|---|---|
| `sidecar` | `prefix + f`, `prefix + F` | TUI de gestion des sessions tmux |
| `regie.nvim` | `nvim/lua/plugins/claude.lua` | régie Neovim du travail de l'agent |

Une URL vide dans `bootstrap.sh` signifie que le dépôt n'existe que sur la
machine d'origine : il reste à publier avant qu'une autre machine puisse s'en
servir.
