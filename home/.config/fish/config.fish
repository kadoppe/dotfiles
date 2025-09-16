set fish_greeting ""

# aliases
alias vi=nvim
alias vim=nvim
alias lzd=lazydocker
alias lg=lazygit
alias ls='eza --icons --git'
alias lt='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
alias ltl='eza -T -L 3 -a -I "node_modules|.git|.cache" -l --icons'
alias cc='claude --dangerously-skip-permissions'
alias co='codex --dangerously-bypass-approvals-and-sandbox'

set -gx EDITOR 'nvim'

# path
set -gx PATH $PATH $HOME/.krew/bin
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

# gcloud
set -x USE_GKE_GCLOUD_AUTH_PLUGIN True

# go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
/opt/homebrew/bin/mise activate fish | source
# direnv
eval (direnv hook fish)

# mysql-client
# fish_add_path /opt/homebrew/opt/mysql-client/bin
fish_add_path /opt/homebrew/opt/mysql-client@8.4/bin

# starship
starship init fish | source

# fzf
fzf --fish | source
function fish_user_key_bindings
  bind \c] prj
end

# lazygit
set -x XDG_CONFIG_HOME $HOME/.config

# ripgrep
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc

# 1password
set -x SSH_AUTH_SOCK $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

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

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Load local config if it exists (for environment variables not committed to Git)
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
