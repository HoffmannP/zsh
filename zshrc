# Path to your oh-my-zsh installation.
  export ZSH=/home/ber/.zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
autoload -U promptinit && promptinit
if [[ $(hostname) == "berli" ]]; then
    color1="yellow";
else
    color1="cyan";
fi
ZSH_THEME="robbyrussell"
ZSH_THEME="lambda (mod)"
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
plugins=(colored-man-pages colorize command-not-found compleat docker git golang)

# User configuration

  export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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
# export GOROOT="/home/ber/Code/go"
# export GOBIN=$GOROOT"/bin"
# export PATH=$PATH:$HOME/.bin:$GOBIN
# export GOPATH=/usr/share/go
# export PATH=$PATH:${GOPATH//://bin:}/bin

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# GPG homedir
export GNUPGHOME=/home/ber/Dropbox/Schluessel/gpg-conf

# short for exit
alias xit=exit

# alias for rmate
alias rsubl=rmate

# play atmospheriy sound
alias atmo="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +30 fade h 1 86400 1"

# apt-get update upgrade
alias -g update-upgrade="apt update && apt upgrade"

# ldap un-base64
alias un64='awk '\''BEGIN{FS=":: ";c="base64 -d"}{if(/\w+:: /) {print $2 |& c; close(c,"to"); c |& getline $2; close(c); printf("%s: %s\n", $1, $2); next} print $0 }'\'''

# add custom completion scripts
fpath+="$HOME/.zsh/completion"
autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit

# wakeup Server
alias wakeup="/usr/bin/wakeonlan BC:5F:F4:79:71:18"

# make file/directory mine
alias mine="sudo chown --changes --recursive $(id -un):$(id -gn)"

# header anzeigen
alias -g _header="tee >(tput smso; head -1 | cat; tput rmso) | cat"

# debase64 for LDAP
alias un64='awk '\''BEGIN{FS=":: ";c="base64 -d"}{if(/\w+:: /) {print $2 |& c; close(c,"to"); c |& getline $2; close(c); printf("%s: %s\n", $1, $2); next} print $0 }'\'''

# create a new project
function newProject {
	git clone https://github.com/HoffmannP/skeleton.git . && ./init.sh
}

# set Options for LESS
LESS="-FKRX"

# local webserver
alias webserver="docker run --name local-webserver --publish 80:80 --volume "/home/ber/Code:/usr/share/nginx/html:ro" -d nginx"

alias aus="sudo poweroff"
alias beKatja="sudo macchanger -m 50:F0:D3:14:84:5A wlp3s0"

# Keybindings
# F1
function list-dir {
	ls -l
	echo
	zle reset-prompt
}
zle -N list-dir
bindkey '^[OP' list-dir

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

# F5
function exec-last-cmd {
	$(fc -ln -1)
	echo
	zle reset-prompt
}
zle -N exec-last-cmd
bindkey '^[[15~' exec-last-cmd

# F6
function show-time {
	clear
	for ((i=0; i<5; i++)); do
		echo
	done
	banner '     '$(date +%R)
	for ((i=0; i<5; i++)); do
		echo
	done
	echo
	zle reset-prompt
}
zle -N show-time
bindkey '^[[17~' show-time

# F8
function run-as-sudo {
	sudo $(fc -ln -1)
	echo
	zle reset-prompt
}
zle -N run-as-sudo
bindkey '^[19' run-as-sudo

hash -d kt="$HOME/Code/Kompetenztest/"
source ~/.zsh/arbeit.sh