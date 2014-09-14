ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git bundler cap gem git-extras osx rails ruby hub autojump brew vagrant tmuxinator)
source $ZSH/oh-my-zsh.sh

# PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=$HOME/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH

# editor
export EDITOR='vim'

# 移動した後は 'ls' する
function chpwd() { ls -F }

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

# settings for each OS
[[ -f ~/.zshrc.osx ]] && source ~/.zshrc.osx
[[ -f ~/.zshrc.debian ]] && source ~/.zshrc.debian
