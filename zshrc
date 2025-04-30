export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME=~/apps/java21
export PATH=$JAVA_HOME/bin:$PATH

ZSH_THEME="robbyrussell"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

export JAVA_HOME="/opt/homebrew/opt/openjdk@21/bin/java"

bindkey '&' autosuggest-accept

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME
alias mem="leaks --atExit --"
alias ssh1="ssh debian@192.168.64.8"
alias ssh2="ssh cesar@192.168.1.195"
alias dark="kitty +kitten themes --reload-in=all Kanagawa"
alias light="kitty +kitten themes --reload-in=all Everforest light soft"

export PATH="$PATH:/Users/cefue/.local/bin"
export PATH="$PATH:/home/cefuente/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
