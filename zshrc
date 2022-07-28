# Path to your oh-my-zsh installation.
export ZSH=~/.zsh/oh-my-zsh

export TERM=xterm

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
autoload -U promptinit && promptinit

ZSH_THEME="adam3"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages colorize command-not-found compleat docker git golang ssh-agent)

# User configuration

# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# You may need to manually set your language environment
export LANG=de_DE.UTF-8

# Preferred editor
export EDITOR='nano'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# set tabulator width
tabs 4 > /dev/null

# settings for GO
# export GOPATH="$HOME/Code/go"
# export PATH="$PATH:$GOPATH/bin"

# GPG homedir
export GNUPGHOME=/home/p2lebe/Dropbox/Schluessel/gpg-conf

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

# Alias for cat
alias cat=bat

# short for exit
alias xit=exit

# apt-get update upgrade
alias -g update-upgrade="apt update && apt upgrade"

# ldap un-base64
alias un64='awk '\''BEGIN{FS=":: ";c="base64 -d"}{if(/\w+:: /) {print $2 |& c; close(c,"to"); c |& getline $2; close(c); printf("%s: %s\n", $1, $2); next} print $0 }'\'''

# nice image viewer
alias -g xpic="feh -r -Z -F -Y" .

# add custom completion scripts
fpath+="$HOME/.zsh/completion"
autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit
kitty + complete setup zsh | source /dev/stdin

# wakeup Server
alias wakeup="/usr/bin/wakeonlan BC:5F:F4:79:71:18"

# make file/directory mine
alias mine='sudo chown --changes --recursive $(id -un):$(id -gn)'

# header anzeigen
alias -g _header="tee >(tput smso; head -1 | cat; tput rmso) | cat"

# docker get IP
alias -g 'docker-ip'="docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"

# debase64 for LDAP
alias un64='awk '\''BEGIN{FS=":: ";c="base64 -d"}{if(/\w+:: /) {print $2 |& c; close(c,"to"); c |& getline $2; close(c); printf("%s: %s\n", $1, $2); next} print $0 }'\'''

# create a new project
function newProject {
	git clone https://github.com/HoffmannP/skeleton.git . && ./init.sh
}

# set Options for LESS
LESS="-FKRX"

alias aus="sudo poweroff"

# Keybindings
# F4
function exit-terminal {
	clearLines=$[(LINES - 7) / 2];
	echo $clearLines

	clear
	for ((i = 0; i < $clearLines; i++)); do
		echo ""
	done
	banner '         3'
	sleep 1s

	clear
	for ((i = 0; i < $clearLines; i++)); do
		echo ""
	done
	banner '         2'
	sleep 1s

	clear
	for ((i = 0; i < $clearLines; i++)); do
		echo ""
	done
	banner '         1'
	sleep 1s

	clear
	for ((i = 0; i < $clearLines; i++)); do
		echo ""
	done
	banner '         *'
	sleep .5s

	clear
	for ((i = 2; i < $clearLines; i++)); do
		echo ""
	done
	banner '         .'
	sleep .5s

	exit
}
zle -N exit-terminal
bindkey '^[OS' exit-terminal

# alias LS
alias ls='exa --icons'

alias unlock="DISPLAY=:0 cinnamon-screensaver-command -d"

# Node Version Management
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Create key/cert
alias sslKey="openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem"

PATH=$PATH:$HOME/.local/bin

# Kitty
alias icat="kitty +kitten icat"
alias idiff="kitty +kitten diff"
function iplot {
    cat <<EOF | gnuplot
    set terminal pngcairo enhanced font 'Fira Sans,10'
    set autoscale
    set samples 1000
    set output '|kitty +kitten icat --stdin yes'
    set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"#fdf6e3" behind
    plot $@
    set output '/dev/null'
EOF
}

alias sesam_oeffne_dich="sudo veracrypt -t ~/Lehrcloud/Space -k '' --pim=0 --protect-hidden=no /media/veracrypt1"
alias sesam_schliesse_dich="sudo veracrypt -t -d ~/Lehrcloud/Space"
