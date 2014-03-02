ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git bundler cap gem git-extras osx rails ruby hub autojump brew vagrant tmuxinator nyan)
source $ZSH/oh-my-zsh.sh

# PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=$HOME/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH

# dircolors
eval $(gdircolors ~/.dir_colors)
alias ls='gls --color=auto'

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

# zaw
source $HOME/.zsh_plugin/zaw/zaw.zsh
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

# added by travis gem
[ -f /Users/kadoppe/.travis/travis.sh ] && source /Users/kadoppe/.travis/travis.sh

export PYTHONPATH=/usr/local/lib/python2.7/site-packages

# byobu
export BYOBU_PREFIX=$(brew --prefix)

# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
