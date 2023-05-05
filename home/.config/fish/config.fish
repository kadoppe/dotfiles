set fish_greeting ""

# aliases
alias vi=nvim
alias vim=nvim
alias mux=tmuxinator
alias lzd=lazydocker

set -gx EDITOR 'nvim'

# path
set PATH /opt/homebrew/bin $PATH
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

# gcloud
set -x USE_GKE_GCLOUD_AUTH_PLUGIN True

# go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# pyenv
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

# openssl
set -x CPPFLAGS -I/usr/local/opt/openssl/include
set -x LDFLAGS -L/usr/local/opt/openssl/lib

# openjdk
set PATH /opt/homebrew/opt/openjdk/bin $PATH

# nvm
set -gx NVM_DIR ~/.nvm

# direnv
eval (direnv hook fish)

# starship
starship init fish | source

# fzf
function fish_user_key_bindings
  bind \c] prj
end

# see also: https://blog.abekoh.dev/posts/prj-command
function prj -d "start project"
  if test (count $argv) -gt 0
    set prjflag --query "$argv"
  end

  set PRJ_PATH (ghq root)/(ghq list | fzf-tmux -p 90% $prjflag)
  if test -z $PRJ_PATH
    return
  end

  set PRJ_NAME (echo (basename (dirname $PRJ_PATH))/(basename $PRJ_PATH) | sed -e 's/\./_/g')
  if not tmux has-session -t $PRJ_NAME > /dev/null 2>&1
    tmux new-session -c $PRJ_PATH -s $PRJ_NAME -d
    tmux setenv -t $PRJ_NAME TMUX_SESSION_PATH $PRJ_PATH
  end

  if test -z $TMUX
    tmux attach -t $PRJ_NAME
  else
    tmux switch-client -t $PRJ_NAME
  end
end

