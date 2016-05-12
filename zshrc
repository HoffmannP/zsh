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
export EDITOR="/usr/bin/nano"

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

# play atmospheriy sound
alias atmo="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +30 fade h 1 86400 1"

# apt-get update upgrade
alias -g update-upgrade="update && sudo apt-get -y dist-upgrade"

# add custom completion scripts
fpath+="$HOME/.zsh/completion"
autoload -U compinit && compinit

# wakeup Server
alias wakeup="/usr/bin/wakeonlan BC:5F:F4:79:71:18"

# make file/directory mine
alias mine="sudo chown --changes --recursive $(id -un):$(id -gn)"

# header anzeigen
alias -g _header="tee >(tput smso; head -1 | cat; tput rmso) | cat"

# set Options for LESS
LESS="-FKRX"
