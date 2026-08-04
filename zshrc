export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(
  git
)
source $ZSH/oh-my-zsh.sh

o() {
    if [[ $# -eq 0 ]]; then
        return 1
    fi
    ollama run llama3.1:8b-instruct-q4_0 "$*"
}

alias O="ollama run llama3.1:8b-instruct-q4_0"

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

export PATH="$PATH:/Users/cefue/.local/bin"
export PATH="$PATH:/home/cefuente/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use default --silent >/dev/null 2>&1

alias m="make"

# Chess
alias chess="python3 /home/cesar/src/clichess/main.py"

# Kanata
alias kr="systemctl --user restart kanata"
alias ks="systemctl --user stop kanata"
alias kst="systemctl --user status kanata"

export EDITOR=nvim
export VISUAL=nvim
bindkey -v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

alias jira-sync="python3 ~/vault/scripts/jira_sync.py"

export MCP_CLIENT_SECRET="***SECRET-REVOQUE***"

# Google Cloud SDK — chargé seulement s'il est réellement installé
for _gcloud_dir in \
  "$HOME/google-cloud-sdk" \
  /usr/share/google-cloud-sdk \
  /usr/lib/google-cloud-sdk \
  /opt/google-cloud-sdk \
  "${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/share/google-cloud-sdk"
do
  if [ -f "$_gcloud_dir/path.zsh.inc" ]; then
    source "$_gcloud_dir/path.zsh.inc"
    [ -f "$_gcloud_dir/completion.zsh.inc" ] && source "$_gcloud_dir/completion.zsh.inc"
    break
  fi
done
unset _gcloud_dir
