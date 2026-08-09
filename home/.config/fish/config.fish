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

# Herdr restores native sessions with canonical command names. Apply the same
# permission settings as cc/co only to those automatically resumed sessions.
function claude --wraps=claude --description 'run Claude Code with Herdr resume defaults'
  if set -q HERDR_ENV; \
      and contains -- --resume $argv; \
      and not contains -- --dangerously-skip-permissions $argv
    command claude --dangerously-skip-permissions $argv
  else
    command claude $argv
  end
end

function codex --wraps=codex --description 'run Codex with Herdr resume defaults'
  if set -q HERDR_ENV; \
      and test (count $argv) -gt 0; \
      and test "$argv[1]" = resume; \
      and not contains -- --dangerously-bypass-approvals-and-sandbox $argv
    command codex --dangerously-bypass-approvals-and-sandbox $argv
  else
    command codex $argv
  end
end

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

function __ensure_herdr_server -d "start the herdr server if it is not running"
  if herdr status server 2> /dev/null | grep -q "status: running"
    return 0
  end

  herdr server > /dev/null 2>&1 &
  disown

  for i in (seq 30)
    if herdr status server 2> /dev/null | grep -q "status: running"
      return 0
    end
    sleep 0.2
  end

  echo "herdr サーバの起動に失敗しました" >&2
  return 1
end

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
  __ensure_herdr_server; or return

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

function prv -d "pick a review-requested PR, create a worktree, and start a review agent"
  if test (count $argv) -gt 0
    set prvflag --query "$argv"
  end

  set PR_JSON (gh pr list --search "review-requested:@me" --json number,title,author,headRefName,isDraft --limit 50)
  if test $status -ne 0
    echo "prv: gh pr list に失敗しました（git リポジトリの中で実行していますか？）" >&2
    return 1
  end

  set PR_LINES (echo $PR_JSON | jq -r '.[] | "\(.number)\t\(if .isDraft then "[Draft] " else "" end)\(.title) (@\(.author.login))"')
  if test -z "$PR_LINES"
    echo "prv: レビュー依頼はありません"
    return 0
  end

  # 番号を隠さない（表示にも検索にも使うため）。選択後は tab 区切りの 1 列目から取り出す
  set SELECTED (printf '%s\n' $PR_LINES | fzf --delimiter \t $prvflag)
  if test -z "$SELECTED"
    return 0
  end

  set PR_NUM (string split -f1 \t $SELECTED)
  set HEAD_REF (echo $PR_JSON | jq -r --argjson n $PR_NUM '.[] | select(.number == $n) | .headRefName')
  set WT_NAME review-$PR_NUM

  set WT_PATH (git gtr go $WT_NAME 2>/dev/null)
  if test -z "$WT_PATH"
    echo "prv: worktree $WT_NAME を作成します ($HEAD_REF)"
    git gtr new $HEAD_REF --track remote --folder $WT_NAME --yes; or return
    set WT_PATH (git gtr go $WT_NAME); or return
  else
    echo "prv: 既存の worktree $WT_NAME を開きます"
  end

  __ensure_herdr_server; or return

  set OPEN_JSON (herdr worktree open --cwd $PWD --path $WT_PATH --label $WT_NAME --focus)
  if test $status -ne 0
    echo "prv: herdr ワークスペース $WT_NAME を開けませんでした" >&2
    return 1
  end
  set WS_ID (echo $OPEN_JSON | jq -r '.result.workspace.workspace_id')
  set TAB_ID (echo $OPEN_JSON | jq -r '.result.workspace.active_tab_id')

  # NOTE: ワークスペース単位の判定なので、レビュー用ワークスペースで別のエージェントを
  # 動かしていると、それを「レビューエージェント」とみなしてしまう
  set EXISTING_PANE (herdr agent list | jq -r --arg ws $WS_ID '.result.agents[] | select(.workspace_id == $ws) | .pane_id' | head -1)
  if test -n "$EXISTING_PANE"
    herdr agent focus $EXISTING_PANE > /dev/null
    echo "prv: レビューエージェントは既に起動しています"
    return 0
  end

  # herdr agent start の前提は「ペインが対話シェルのプロンプトにいること」であって
  # 「エージェントが検出されていないこと」ではない。nvim などが動いているペインを選ぶと
  # 30 秒待たされた末に失敗するので、フォアグラウンドのプロセスグループがシェル自身か
  # どうかで判定する。アクティブなタブのペインを優先する
  set PANE_ID ""
  for CAND in (herdr pane list --workspace $WS_ID | jq -r --arg t "$TAB_ID" '[.result.panes[] | select(.agent == null)] | sort_by(.tab_id != $t) | .[].pane_id')
    set PROC_INFO (herdr pane process-info --pane $CAND 2>/dev/null); or continue
    set IS_IDLE (echo $PROC_INFO | jq -r '.result.process_info | if .foreground_process_group_id == .shell_pid then "yes" else "no" end')
    if test "$IS_IDLE" = yes
      set PANE_ID $CAND
      break
    end
  end
  if test -z "$PANE_ID"
    echo "prv: $WT_NAME に空いているシェルのペインがありません（実行中のコマンドを終えるか、ペインを分割してください）" >&2
    return 1
  end

  # herdr の「利用可能なシェル」判定は上のプロセスグループ判定より厳しい。作りたての
  # ワークスペースでは fish が config.fish を読んでいる間もフォアグラウンドのプロセス
  # グループはシェル自身なので、上を通っても agent start が agent_pane_busy で弾かれる。
  # PaneInfo に準備完了を示すフィールドが無いため、プロンプトに到達するまで粘る
  set STARTED 0
  set START_OUT ""
  for i in (seq 25)
    set START_OUT (herdr agent start $WT_NAME --kind claude --pane $PANE_ID -- --dangerously-skip-permissions 2>&1)
    if test $status -eq 0
      set STARTED 1
      break
    end
    # プロンプト待ち以外のエラーは粘っても変わらない
    if not string match -q '*agent_pane_busy*' -- "$START_OUT"
      break
    end
    sleep 0.4
  end
  if test $STARTED -ne 1
    echo "prv: ペイン $PANE_ID で Claude を起動できませんでした: $START_OUT" >&2
    return 1
  end
  if not herdr agent prompt $WT_NAME "/review-pr $PR_NUM" > /dev/null
    echo "prv: /review-pr $PR_NUM の投入に失敗しました（エージェントに手で入力してください）" >&2
    return 1
  end
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
