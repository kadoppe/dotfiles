# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler cap gem git-extras osx rails ruby hub autojump brew vagrant)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=$HOME/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH

# node
export PATH=$HOME/.nodebrew/current/bin:$PATH
nodebrew use v0.10.22

# go
export GOPATH=~/.go

# 移動した後は 'ls' する
function chpwd() { ls -F }

# macvim
alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi=vim
export PATH="/Applications/MacVim.app/Contents/MacOS:$PATH"

# hub
alias git='nocorrect hub'
compdef hub=git
function mkcd(){mkdir -p $1 && cd $1}
source /Users/kadoppe/.zsh_plugin/zaw/zaw.zsh

# zaw
bindkey '^h' zaw-history

# history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_expand

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# tex
export PATH=/usr/texbin:$PATH

# cabal
export PATH=$HOME/.cabal/bin:$PATH
