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
alias gtr='git gtr'

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
fish_add_path --prepend --move ~/.local/share/mise/shims
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

  # exclude gtr worktree checkouts (<repo>-worktrees/...) from candidates
  set PRJ_PATH (ghq root)/(ghq list | grep -v -- '-worktrees/' | fzf $prjflag)
  if test -z $PRJ_PATH
    return
  end

  set PRJ_NAME (basename (dirname $PRJ_PATH))/(basename $PRJ_PATH)

  # the herdr CLI doesn't auto-start the server
  if not herdr status server 2> /dev/null | grep -q "status: running"
    herdr server > /dev/null 2>&1 &
    disown
    for i in (seq 30)
      herdr status server 2> /dev/null | grep -q "status: running" && break
      sleep 0.2
    end
  end

  set WS_ID (herdr workspace list | jq -r --arg l "$PRJ_NAME" '.result.workspaces[] | select(.label == $l) | .workspace_id')
  if test -z "$WS_ID"
    herdr workspace create --cwd $PRJ_PATH --label $PRJ_NAME --focus > /dev/null
  else
    herdr workspace focus $WS_ID > /dev/null
  end

  if not set -q HERDR_ENV
    herdr
  end
end

function wtn -d "create a worktree with git gtr and open it as a herdr workspace"
  if test (count $argv) -eq 0
    echo "usage: wtn <branch> [git gtr new options...]"
    return 1
  end

  git gtr new $argv; or return
  set WT_PATH (git gtr go $argv[1]); or return
  herdr worktree open --cwd $PWD --path $WT_PATH > /dev/null
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Load local config if it exists (for environment variables not committed to Git)
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

if command -sq kiro; and string match -q "$TERM_PROGRAM" "kiro"
    . (kiro --locate-shell-integration-path fish)
end

# uv
fish_add_path "/Users/kadoppe/.local/bin"
