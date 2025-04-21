# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/Users/miklar/.local/bin:$PATH
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# export SPACESHIP_CONFIG="$HOME/.config/spaceship/spaceship.zsh"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"


# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

NVM_HOMEBREW=$(brew --prefix nvm)
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm)

source $ZSH/oh-my-zsh.sh

# User configuration

eval "$(zoxide init zsh)"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias v=nvim
alias vo='NVIM_APPNAME=nvim-2024 nvim'
alias d=docker
alias dc='docker compose'
alias e='eza -al --group-directories-first'
alias et='eza --group-directories-first --tree --level 5'
alias ff=fzf

alias ez="v $HOME/.zshrc"
alias ea="v $HOME/.oh-my-zsh/custom/alias.zsh"
alias ev="v $HOME/.config/nvim/"

alias t=todo.sh

# source ~/.zshr
alias sc="exec zsh"

export CGO_CFLAGS="-I$(brew --prefix portmidi)/include"
export CGO_LDFLAGS="-L$(brew --prefix portmidi)/lib -lportmidi"


UTILS='/Users/miklar/work/earlybird/utils'
alias forw="$UTILS/env-port-forward.sh"

bnauth() {
  export BIRDNEST_API_TOKEN=$($UTILS/birdnest/birdnest-auth.sh $1 $2)
}
alias bn="$UTILS/birdnest/birdnest.sh"

alias ts=~/.local/bin/tmux-sessionizer

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/miklar/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/miklar/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/miklar/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/miklar/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/miklar/.bun/_bun" ] && source "/Users/miklar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/miklar/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

eval "$(starship init zsh)"

