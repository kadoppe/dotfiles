ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git bundler gem git-extras osx brew tmuxinator)
source $ZSH/oh-my-zsh.sh

# PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=$HOME/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH
export PATH=/opt/mono/bin:$PATH

# editor
export EDITOR='vim'

# 移動した後は 'ls' する
function chpwd() { ls -F }

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*:*:cdr:*:*' menu selection
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
  zstyle ':chpwd:*' recent-dirs-pushd true
fi

# zaw
source $HOME/.zsh_plugin/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes
bindkey '^@' zaw-cdr
bindkey '^R' zaw-history
bindkey '^X^T' zaw-tmux
bindkey '^X^S' zaw-ssh-hosts

# history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_expand

# Pebble SDK
export PATH=$HOME/dev/tools/PebbleSDK-2.6.1/bin:$PATH

# settings for each OS
[[ -f ~/.zshrc.osx ]] && source ~/.zshrc.osx
[[ -f ~/.zshrc.debian ]] && source ~/.zshrc.debian
