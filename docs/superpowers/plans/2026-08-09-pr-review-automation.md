# PR レビュー自動化 (`prv` + `/pr-code-review-with-crit`) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** レビュー依頼された GitHub PR を、1 コマンドで worktree 作成から一次レビュー・crit story 生成まで進める。

**Architecture:** dotfiles 側の fish 関数 `prv` が PR 選択・worktree 作成・herdr ワークスペース起動を担い、mento 側のスラッシュコマンド `/pr-code-review-with-crit` が worktree の中で一次レビューと crit への登録・story 生成を担う。既存の `pr-code-review` スキルは無改変で流用する。

**Tech Stack:** fish shell, `gh` CLI, `jq`, `fzf`, `git gtr` (git worktree runner), `herdr`, `crit`

## Global Constraints

- ユーザーとのやりとりは日本語で行う（`~/.claude/CLAUDE.md`）。fish 関数のメッセージも日本語にする。
- worktree のフォルダ名は `review-<PR番号>` に固定する。既存運用（`review-3527`, `review-4244` 等）に合わせる。
- worktree の存在が「着手済み」マーカー。状態ファイルは作らない。
- `/pr-code-review` スキルは変更しない。
- 自動テストは書かない。各タスクは手動確認コマンドとその期待結果で締める。
- 対象リポジトリは 2 つ。dotfiles = `/Users/kadoppe/.homesick/repos/dotfiles`、mento = `/Users/kadoppe/Sources/github.com/ugokuinc/mento`。**それぞれ別リポジトリなので、コミットは別々に行う。**
- 設計の根拠は `docs/superpowers/specs/2026-08-09-pr-review-automation-design.md`。

## File Structure

| ファイル | 責務 |
|---|---|
| `home/.config/fish/config.fish`（dotfiles・変更） | `__ensure_herdr_server` ヘルパー、`prj` のリファクタ、`prv` の追加 |
| `home/.claude/commands/pr-code-review-with-crit.md`（dotfiles・新規） | worktree 内で一次レビュー → crit 登録 → story 生成をオーケストレートする。**当初は mento リポジトリに置く計画だったが、`prv` の worktree は PR の head ブランチをチェックアウトするためリポジトリ管理下のコマンドは見えない。ユーザーレベル（`~/.claude` は dotfiles の `home/.claude` への symlink）に移した。** |
| `docs/superpowers/specs/2026-08-09-pr-review-automation-design.md`（dotfiles・変更） | Task 3 で実測した crit の review file 解決順序を追記する |

---

### Task 1: `__ensure_herdr_server` の切り出しと `prj` の置き換え

herdr サーバの起動待ちロジックは `prj` の中にインラインで書かれている。`prv` でも同じものが要るので、先に関数へ切り出す。

**Files:**
- Modify: `home/.config/fish/config.fish:114-124`（`prj` 内の herdr サーバ起動ブロック）

**Interfaces:**
- Consumes: なし
- Produces: `__ensure_herdr_server` — 引数なし。herdr サーバが起動していれば即座に 0 を返す。起動していなければバックグラウンドで起動し、最大 6 秒（0.2 秒 × 30 回）待つ。起動を確認できたら 0、タイムアウトしたら 1 を返す。

- [ ] **Step 1: `__ensure_herdr_server` を追加する**

`home/.config/fish/config.fish` の `function prj` の定義の**直前**に以下を挿入する。

```fish
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
```

- [ ] **Step 2: `prj` の中のインライン版を置き換える**

`prj` の中の以下のブロックを削除する。

```fish
  # the herdr CLI doesn't auto-start the server
  if not herdr status server 2> /dev/null | grep -q "status: running"
    herdr server > /dev/null 2>&1 &
    disown
    for i in (seq 30)
      herdr status server 2> /dev/null | grep -q "status: running" && break
      sleep 0.2
    end
  end
```

削除した位置に以下を書く。

```fish
  # the herdr CLI doesn't auto-start the server
  __ensure_herdr_server; or return
```

- [ ] **Step 3: 構文チェックと動作確認**

Run:
```bash
fish -n home/.config/fish/config.fish && echo "syntax OK"
fish -c 'source home/.config/fish/config.fish; __ensure_herdr_server; echo "exit=$status"'
```

Expected: `syntax OK` が出て、続けて `exit=0` が出る。herdr サーバが既に起動している場合も、止まっている状態から起動する場合も 0 になること。

herdr サーバが起動していることを別途確認する。

Run: `herdr status server`
Expected: `status: running` を含む出力。

- [ ] **Step 4: コミット**

```bash
cd /Users/kadoppe/.homesick/repos/dotfiles
git add home/.config/fish/config.fish
git commit -m "refactor(fish): extract __ensure_herdr_server from prj"
```

---

### Task 2: `prv` fish 関数の追加

**Files:**
- Modify: `home/.config/fish/config.fish`（`wtn` 関数の直後に追加）

**Interfaces:**
- Consumes: `__ensure_herdr_server`（Task 1）
- Produces: `prv [query]` — レビュー依頼 PR を fzf で選び、`review-<番号>` worktree を用意し、herdr ワークスペースでエージェントに `/pr-code-review-with-crit <番号>` を投げる。

- [ ] **Step 1: `git gtr go` の未存在時の挙動を確認する**

`prv` は「worktree が既にあるか」を `git gtr go` の成否で判定する。まずその挙動を実測する。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento
git gtr go review-9999999 2>/dev/null; echo "exit=$?"
git gtr go review-4269 2>/dev/null; echo "exit=$?"
```

Expected: 存在しない `review-9999999` は stdout が空（または非ゼロ終了）。存在する `review-4269` はパスを 1 行だけ出力して `exit=0`。

**stdout が空にならない、あるいは存在しない場合も `exit=0` になる場合は、Step 3 のコードの判定を `test -d`（worktree パスの直接確認）に差し替えること。** 判定方法は実測結果に合わせる。想定で決め打ちしない。

- [ ] **Step 2: `herdr agent start` / `herdr agent prompt` の引数を確認する**

Run:
```bash
herdr agent start --help
herdr agent prompt --help
```

Expected: それぞれの必須引数（ペイン ID の指定が要るか、フォーカス中のペインが既定になるか、プロンプト本文の渡し方）が判明する。

**フォーカス中のペインが既定にならない場合は、`herdr worktree open` の出力からペイン ID を取り出して渡すこと。** `herdr worktree open` の戻り値は JSON なので、`jq` で取得できる。Step 3 のコードはこの実測結果に合わせて調整する。

- [ ] **Step 3: `prv` を追加する**

`home/.config/fish/config.fish` の `wtn` 関数の**直後**に以下を挿入する。Step 1 / Step 2 の実測結果に応じて、worktree 存在判定とエージェント起動の 2 箇所を調整すること。

```fish
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

  set SELECTED (printf '%s\n' $PR_LINES | fzf --delimiter \t --with-nth 2.. $prvflag)
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

  herdr worktree open --cwd $PWD --path $WT_PATH --label $WT_NAME --focus > /dev/null; or return
  herdr agent start > /dev/null; or return
  herdr agent prompt "/pr-code-review-with-crit $PR_NUM" > /dev/null
end
```

- [ ] **Step 4: 構文チェック**

Run: `fish -n home/.config/fish/config.fish && echo "syntax OK"`
Expected: `syntax OK`

- [ ] **Step 5: PR 一覧の取得と選択部分だけを確認する**

worktree を作らずに、一覧の組み立てが正しいかだけ先に見る。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento
gh pr list --search "review-requested:@me" --json number,title,author,headRefName,isDraft --limit 50 \
  | jq -r '.[] | "\(.number)\t\(if .isDraft then "[Draft] " else "" end)\(.title) (@\(.author.login))"'
```

Expected: `4270<TAB>feat: プロジェクト詳細の複製（コピー）を GraphQL 接続 [MNT-7057] (@poster-keisuke)` のような行が複数出る。番号・タイトル・作者が正しく入っていること。Draft の PR には `[Draft] ` が付くこと。

- [ ] **Step 6: 既存 worktree での冪等性を確認する**

`review-4269` は検証済みで既に存在する。これを対象に `prv` を実行し、worktree が二重に作られないことを見る。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento
fish -c 'source ~/.homesick/repos/dotfiles/home/.config/fish/config.fish; prv 4269'
git worktree list | grep -c review-4269
```

Expected: `prv: 既存の worktree review-4269 を開きます` が出て、`git worktree list` の該当行は `1` 件のまま。herdr でワークスペースが focus され、Claude が起動して `/pr-code-review-with-crit 4269` が入力されること。

**`/pr-code-review-with-crit` は `home/.claude/commands/pr-code-review-with-crit.md`（ユーザーレベル）にあるので、Task 4 まで進んでいれば Claude 側で認識される。**「コマンドが見つからない」と返ってきたら、それは想定内の状態ではなく本当の失敗なので、コマンドファイルの配置と frontmatter を確認すること。Task 4 より前にこの Step を実行している場合に限り、コマンド未作成による not found が正しい状態。

- [ ] **Step 7: 新規 worktree の作成を確認する**

まだ worktree の無い PR を 1 つ選んで実行する。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento
fish -c 'source ~/.homesick/repos/dotfiles/home/.config/fish/config.fish; prv'
```

Expected: fzf で PR を選ぶと `prv: worktree review-<番号> を作成します` が出て、`/Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-<番号>` が作られる。

作られた worktree の状態を確認する。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-<番号>
git rev-parse --abbrev-ref --symbolic-full-name @{u}
```

Expected: `origin/<PR の headRefName>` が返る。

- [ ] **Step 8: コミット**

```bash
cd /Users/kadoppe/.homesick/repos/dotfiles
git add home/.config/fish/config.fish
git commit -m "feat(fish): add prv to open review-requested PRs in a worktree"
```

---

### Task 3: crit の review file 解決順序を実測して決める

`crit comment` は cwd とブランチから review を解決し、`crit story` は diff スコープから review を作る。この 2 つが同じ review file を指さないと、一次レビューのコメントが story のブラウザに出てこない。**Task 4 の手順の並びがこの結果で決まるので、先に実測する。**

**Files:**
- Modify: `docs/superpowers/specs/2026-08-09-pr-review-automation-design.md`（「review file のスコープ問題」節に結論を追記）

**Interfaces:**
- Consumes: Task 2 で作られた `review-4269` worktree
- Produces: Task 4 が採用する手順の並び（「コメント先行」か「story スタブ先行」か）

- [ ] **Step 1: コメント先行の順序を試す**

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-4269
crit comment --author 'Claude Code' 'scope 検証用のダミーコメント'
crit status --json
```

Expected: コメントが登録され、`crit status --json` が review file のパスを返す。**そのパスを記録する。**

- [ ] **Step 2: story 側が同じ review file を使うか確認する**

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-4269
crit story --pr 4269 --skip-llm --no-open
crit status --json
crit comments --all
```

Expected: `crit status --json` が返す review file のパスが Step 1 と一致し、`crit comments --all` にダミーコメントが残っていること。

- [ ] **Step 3: 結果に応じて採用順序を決める**

- **一致し、コメントが残っている場合** → 採用順序は「コメント先行」。Task 4 は `crit comment` → `/crit-story` の並びにする。
- **一致しない、またはコメントが消えている場合** → 採用順序は「story スタブ先行」。Task 4 は `crit story --pr <番号> --skip-llm --no-open` → `crit comment` → `crit story --refresh` の並びにする。

- [ ] **Step 4: 検証用データを片付ける**

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-4269
crit comment --clear
crit story --clear
crit status --json
```

Expected: コメントと story が消えていること。

- [ ] **Step 5: 設計ドキュメントに結論を追記する**

`docs/superpowers/specs/2026-08-09-pr-review-automation-design.md` の「review file のスコープ問題」節の末尾に、実測日・実行したコマンド・観測結果・採用した順序を 3〜5 行で追記する。「どちらの順序になるかは実装時に実測して決める」という文は、決まった順序の記述に置き換える。

- [ ] **Step 6: コミット**

```bash
cd /Users/kadoppe/.homesick/repos/dotfiles
git add docs/superpowers/specs/2026-08-09-pr-review-automation-design.md
git commit -m "docs: record measured crit review file resolution order"
```

---

### Task 4: `/pr-code-review-with-crit` スラッシュコマンドの追加

**Files:**
- Create: `/Users/kadoppe/.homesick/repos/dotfiles/home/.claude/commands/pr-code-review-with-crit.md`（= `~/.claude/commands/pr-code-review-with-crit.md`）

**Interfaces:**
- Consumes: Task 3 で決めた crit の手順の並び。`prv`（Task 2）が `/pr-code-review-with-crit <PR番号>` の形で起動する。
- Produces: なし（最終成果物）

- [ ] **Step 1: 既存コマンドの書式を確認する**

Run: `cat /Users/kadoppe/Sources/github.com/ugokuinc/mento/.claude/commands/create-pr.md`

Expected: frontmatter に `allowed-tools` と `description`、本文に `## Context` と `## Your task` を持つ構成。`!\`command\`` でシェル実行結果を埋め込み、`$ARGUMENTS` で引数を受ける。**この書式に合わせる。**

- [ ] **Step 2: `pr-code-review-with-crit.md` を作成する**

`home/.claude/commands/pr-code-review-with-crit.md` に以下の内容で作成する。**ステップ 3 の crit の手順は Task 3 の実測結果に置き換えること。** 下記は「コメント先行」を採用した場合の版。

なお実装済みの最終版は下書きから 2 点変わっている。(1) 冒頭の実行場所チェックは、ディレクトリ名ではなく origin が `ugokuinc/mento` であることとカレントブランチが PR の head ブランチであることで判定する（ユーザーレベルに置いたのでどのリポジトリからでも起動できてしまうため）。(2) story 生成は `crit:crit-story` スキルに委譲せず、`crit story --guide` / `--prep` / `--story-file --refresh` を手順として直接書き下す（スキルの手順は `--pr` と `--refresh` を落とすため）。

````markdown
---
allowed-tools: Bash(git *), Bash(gh *), Bash(crit *), Skill(pr-code-review), Skill(crit:crit-story)
description: レビュー依頼された PR の一次レビューを実行し、指摘を crit に登録して crit story を開きます。prv 関数から起動されます。
---

## Context

- PR 番号: $ARGUMENTS
- Current branch: !`git branch --show-current`
- Worktree path: !`pwd`

## Your task

PR $ARGUMENTS の一次レビューを行い、crit で最終レビューできる状態にする。以下の手順に従うこと。

### ステップ1: 一次レビュー

`pr-code-review` スキルを PR 番号 $ARGUMENTS を指定して実行する。

このスキルはリポジトリ相対のガイドライン（`backend/mento-backend/CLAUDE.md` など）を読むため、**cwd が worktree の中であることを前提とする**。`pwd` が `mento-worktrees/review-$ARGUMENTS` でない場合は、その旨を報告して中断すること。

### ステップ2: 指摘を crit に登録

ステップ1 のレビュー結果を crit のコメント JSON に変換し、一時ファイルに書いてから一括投入する。

- 行単位の指摘: `{"file": "<リポジトリ相対パス>", "line": <行番号>, "body": "<指摘>"}`
- 範囲指定: `{"file": "...", "line": "45-47", "body": "..."}`
- ファイル全体の指摘: `{"path": "<パス>", "body": "..."}`
- 全体所感: `{"body": "...", "scope": "review"}`

**本文が複数行になるため、stdin パイプではなく必ず Write ツールで一時ファイルを書いてから `--file` で渡すこと。** 生の改行を含む JSON をシェルの引用符で渡すと壊れる。

```bash
crit comment --json --file <一時ファイルパス> --author 'Claude Code'
```

`line` はディスク上のファイルの行番号（1 始まり）であって、diff の行番号ではない。

指摘が 0 件の場合も、全体所感を `scope: "review"` で 1 件登録する。

### ステップ3: story の生成

`crit:crit-story` スキルを起動し、この PR の diff に対する story を生成・ingest する。ブラウザが開く。

### ステップ4: 引き継ぎ

以下をユーザーに伝えて終了する。

- 一次レビューの指摘件数（🔴 / 🟡 の内訳）
- crit のブラウザが開いていること
- 最終レビューで追記したコメントは `crit push $ARGUMENTS` で GitHub PR に反映できること
- レビューが終わったら `git gtr rm review-$ARGUMENTS` で worktree を片付けること
````

- [ ] **Step 3: worktree の中で単体実行する**

`prv` を経由せず、直接コマンドを叩いて通しで動くか見る。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-4269
claude --dangerously-skip-permissions
```

起動した Claude に `/pr-code-review-with-crit 4269` と入力する。

Expected:
- `/pr-code-review-with-crit` がユーザーレベルのコマンドとして認識される（`review-4269` のブランチは PR 4269 の head ブランチなので、冒頭の実行場所チェックを通る）
- `pr-code-review` スキルが走り、レビュー結果が出る
- `crit comment --json --file ...` が成功する
- crit のブラウザが開き、**story と一次レビューのコメントの両方が表示される**

**「コマンドが見つからない」と返る場合は配置の問題。** `ls ~/.claude/commands/pr-code-review-with-crit.md` で存在を確認する（`~/.claude` は dotfiles の `home/.claude` への symlink なので、homesick の貼り直しは不要）。

**コメントが story 側に出てこない場合は Task 3 の結論が誤っている。** Task 3 に戻って順序を測り直し、このコマンドの手順を修正すること。

- [ ] **Step 4: `prv` から通しで実行する**

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento
git gtr rm review-4269
fish -c 'source ~/.homesick/repos/dotfiles/home/.config/fish/config.fish; prv 4269'
```

Expected: worktree が新規作成され、herdr ワークスペースが開き、Claude が起動して `/pr-code-review-with-crit 4269` が自動で投入され、Step 3 と同じ結果になる。ここでもコマンドが認識されること（Task 2 Step 6 の注記のとおり、not found は失敗であって想定内の状態ではない）。

- [ ] **Step 5: `crit push` を確認する**

ブラウザでコメントを 1 件足してから確認する。

Run:
```bash
cd /Users/kadoppe/Sources/github.com/ugokuinc/mento-worktrees/review-4269
crit push --dry-run 4269
```

Expected: GitHub PR #4269 に投稿されるコメントの内容が表示される。**`--dry-run` を外した実投稿は、内容を確認したうえでユーザーの判断で行うこと。勝手に投稿しない。**

- [ ] **Step 6: mento 以外のリポジトリでの挙動を確認する**

Run:
```bash
cd /Users/kadoppe/.homesick/repos/dotfiles
fish -c 'source home/.config/fish/config.fish; prv'
```

Expected: dotfiles のレビュー依頼 PR が候補に出る（0 件なら `prv: レビュー依頼はありません`）。`/pr-code-review-with-crit` 自体はユーザーレベルなので起動はするが、冒頭の実行場所チェック（origin が `ugokuinc/mento` でない）に引っかかって中断する。これは設計どおりの挙動。

- [ ] **Step 7: コミット**

```bash
cd /Users/kadoppe/.homesick/repos/dotfiles
git add home/.claude/commands/pr-code-review-with-crit.md
git commit -m "feat(claude): add /pr-code-review-with-crit as a user-level command"
```

**mento リポジトリには何もコミットしない。** コマンドは dotfiles の `home/.claude/commands/` に置く（当初計画の `feat/pr-code-review-with-crit-command` ブランチは破棄済み）。
