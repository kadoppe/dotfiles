# tmux → herdr 移行 設計

- 日付: 2026-07-04
- 状態: 承認済み

## 背景と目的

現状はリポジトリごとに tmux セッションを作って開発している。
入口は `prj` 関数（ghq + fzf、Ctrl+] バインド）で、worktree ごとのセッション切替は `~/.tmux/scripts/wt.sh`（prefix+w）が担う。
これを herdr（agent-aware terminal multiplexer、0.7.1、brew 導入済み）に完全移行する。
tmux の設定ファイル・プラグインは削除しないが、日常のエントリポイントを herdr にする。

## 決定事項

1. 併用期間を置かず一気に完全移行する
2. `prj` は herdr 版に書き換える（Ctrl+] バインドは維持）
3. worktree 切替は herdr 内蔵機能（open_worktree / new_worktree）を使う
4. prefix は tmux と同じ Ctrl+T に揃える

## 変更内容

### 1. home/.config/herdr/config.toml（新規）

`.homesick_subdir` に `.config/herdr` を追加し、config.toml のみを symlink する。
`~/.config/herdr/` にはログ・ソケット・session.json などのランタイムファイルが置かれるため、ディレクトリごとの symlink はしない。

設定内容:

- `[keys]` prefix = ctrl+t / workspace_picker = prefix+s（tmux の bind s と同じ指）/ open_worktree = prefix+w（tmux の bind w と同じ指）/ settings = prefix+shift+s（prefix+s を picker に譲るため退避）/ split_vertical = prefix+pipe（キー構文で使えなければデフォルトの prefix+v にフォールバック）
- split_horizontal（prefix+minus）、h/j/k/l ペイン移動、copy_mode（prefix+[）、zoom（prefix+z）、new_tab（prefix+c）はデフォルトが tmux とほぼ一致するのでそのまま
- `[ui]` confirm_close = false（tmux の bind x 確認スキップ相当）、prompt_new_tab_name = false（tmux の new-window は名前を聞かない）
- `[theme]` name = catppuccin（組み込み。frappe に寄せたくなったら [theme.custom] で後から調整）
- `[session]` resume_agents_on_restore = true（tmux-resurrect/continuum 相当は herdr の組み込み永続化で置き換え）

### 2. config.fish の prj 書き換え

- ghq list | fzf でリポジトリを選び、`org/repo` を workspace のラベルにする
- サーバー未起動なら `herdr server` をバックグラウンド起動して running を待つ（CLI はサーバーを自動起動しないことを確認済み）
- ラベル一致の workspace があれば `herdr workspace focus`、なければ `herdr workspace create --cwd --label --focus`（jq で JSON をパース）
- `HERDR_ENV` 未設定（= herdr の外）なら最後に `herdr` でアタッチ
- 廃止するもの: fzf-tmux（→ 素の fzf）、tmux セッション名都合だった `.`→`_` 変換、参照箇所のない TMUX_SESSION_PATH

### 3. CLAUDE.md の記述更新

Shell Environment / Development Environment の tmux 前提の記述を herdr に更新する。

## 変えないもの

- .tmux.conf・tmux プラグイン・wt.sh（ファイルとして残す。いつでも戻れる状態を維持）
- ghostty 設定（tmux を自動起動していないため変更不要）
- config.fish の Ctrl+] バインドと未コミットの既存差分（kiro 修正など）

## リスクと対応

- open_worktree の UI 挙動は未検証。動かない場合は wt.sh 相当の fish 関数（git worktree list + fzf + herdr worktree open）にフォールバックする
- tmux の bind L（直前セッションへトグル）に相当する機能は herdr にない。workspace picker（prefix+s）で代替する
- herdr は 0.7 と若いが、tmux 資産を残すためロールバック可能

## 検証

- `homesick symlink dotfiles` 後に ~/.config/herdr/config.toml が symlink になっていること
- `herdr server reload-config` がエラーなく通ること（herdr-server.log も確認）
- workspace の create / list（jq でのラベル検索）/ focus / close の CLI 動作（検証済み）
- `fish -n` で config.fish の構文チェック
