set fish_greeting ""

# aliases
alias vi=nvim
alias vim=nvim
alias lzd=lazydocker
alias lg=lazygit
alias ls='eza --icons --git'
alias lt='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
alias ltl='eza -T -L 3 -a -I "node_modules|.git|.cache" -l --icons'

set -gx EDITOR 'nvim'

# path
set PATH /opt/homebrew/bin $PATH
set -gx PATH $PATH $HOME/.krew/bin
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

# pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source

# gcloud
set -x USE_GKE_GCLOUD_AUTH_PLUGIN True

# go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# mise
fish_add_path ~/.local/share/mise/shims

# openjdk
set PATH /opt/homebrew/opt/openjdk/bin $PATH

# direnv
eval (direnv hook fish)

# starship
starship init fish | source

# fzf
fzf --fish | source
function fish_user_key_bindings
  bind \c] prj
end

# lazygit
set -x XDG_CONFIG_HOME $HOME/.config

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
