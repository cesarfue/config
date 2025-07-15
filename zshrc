export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(
  git
  # zsh-autosuggestions
  # zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

if [[ $OSTYPE == "darwin"* ]]; then
  export JAVA_HOME="/opt/homebrew/Cellar/openjdk@21/21.0.7/libexec/openjdk.jdk/Contents/Home"
elif [[ $OSTYPE == "linux-gnu"* ]]; then
  export JAVA_HOME="$HOME/.local"
fi


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

export PATH="$PATH:/Users/cefue/.local/bin"
export PATH="$PATH:/home/cefuente/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

export PATH=$JAVA_HOME/bin:$PATH

# Load Angular CLI autocompletion.
alias makenode="docker exec -it --user root bosf5_node bash"
