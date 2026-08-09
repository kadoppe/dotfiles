---
allowed-tools: Bash(git *), Bash(gh *), Bash(crit *), Read, Write, Skill(pr-code-review)
description: レビュー依頼された PR の一次レビューを実行し、指摘を crit に登録して crit story を開きます。prv 関数から起動されます。
---

## Context

- PR 番号: $ARGUMENTS
- Current branch: !`git branch --show-current`
- Worktree path: !`git rev-parse --show-toplevel`
- origin の URL: !`git remote get-url origin`
- PR の head ブランチ: !`gh pr view $ARGUMENTS --json headRefName -q .headRefName`

> **このファイルは mento の `.claude/commands/pr-code-review-with-crit.md` にも置かれている。**
> `prv` の worktree は PR の head ブランチをチェックアウトするため、mento 側だけに置くと
> マージ前に切られた PR からは見えない。だからユーザーレベルにも要る。
> **手順を直したらもう片方も直すこと。** 差分はこの引用ブロックと、直下のステップ0 の
> 書き出し（実行場所の前提の説明）だけ。それ以外は同じ内容に保つ。

## Your task

PR $ARGUMENTS の一次レビューを行い、crit で最終レビューできる状態にする。以下の手順に従うこと。

### ステップ0: 実行場所の確認

ユーザーレベルに置かれた方はどのリポジトリからでも起動できてしまう。後続の手順は「mento の、この PR のブランチをチェックアウトした作業ツリーの中にいること」を前提とするので、先に上記 Context の内容だけで次を確認する。

1. **PR 番号が渡されていること** — `$ARGUMENTS` が空なら、`/pr-code-review-with-crit <PR番号>` の形で呼び直すよう伝えて中断する。
2. **mento のチェックアウトであること** — origin の URL が `ugokuinc/mento` を指していること。
3. **この PR のブランチにいること** — Current branch が「PR の head ブランチ」と一致していること。

Context の「PR の head ブランチ」が空・エラー・あるいは `$ARGUMENTS` の文字列がそのまま残っている場合は、埋め込みの展開に失敗している。その場合は自分で次を実行し、その結果と比較すること（Context の値をそのまま信じて誤って中断しないこと）。

```bash
gh pr view $ARGUMENTS --json headRefName -q .headRefName
```

条件を満たさない場合は、**見つかった値と期待した値の両方を挙げて**中断する。例:

> `/pr-code-review-with-crit 4269` は mento の PR 4269 のブランチをチェックアウトした作業ツリーで実行してください。
> 現在地: `/Users/kadoppe/Sources/github.com/ugokuinc/dotfiles`（ブランチ `master`）
> 期待: origin が `ugokuinc/mento` で、ブランチが `KentaYoshitani/list-in-app-recording-owners`
> `prv 4269` を実行すると、この worktree が用意されます。

**ディレクトリ名ではなくブランチで判定すること。** `pr-code-review` は `backend/mento-backend/CLAUDE.md` などリポジトリ相対のガイドラインを読むため mento のチェックアウトが必須で、`crit comment` は cwd とブランチから review を解決するため、ブランチがずれていると別の review file に書き込まれてコメントが孤立する。`mento-worktrees/review-<番号>` というディレクトリ名は、中のブランチが差し替わっていても一致してしまうので判定材料にしない。

### ステップ1: 一次レビュー

`pr-code-review` スキルを PR 番号 $ARGUMENTS を指定して実行する。

### ステップ2: story スタブの生成（review file を確定させる）

**`crit comment` の前に、必ず先に `crit story` でスタブを作ること。順序を入れ替えてはならない。**

```bash
crit story --pr $ARGUMENTS --skip-llm --no-open
```

`crit comment` は cwd とブランチから review を解決するのに対し、`crit story --pr` は diff スコープから新しい review file を作る。コメント登録を先に行うと、後続の `crit story --pr` が別の review file を新規作成してしまい、先行コメントが孤立して story 側に一切表示されなくなる（実測済み。詳細は dotfiles の `docs/superpowers/specs/2026-08-09-pr-review-automation-design.md` の「review file のスコープ問題」を参照）。

### ステップ3: 指摘を crit に登録

ステップ1 のレビュー結果を crit のコメント JSON に変換し、一時ファイルに書いてから一括投入する。

- 行単位の指摘: `{"file": "<リポジトリ相対パス>", "line": <行番号>, "body": "<指摘>"}`
- 範囲指定: `{"file": "...", "line": "45-47", "body": "..."}`
- ファイル全体の指摘: `{"path": "<パス>", "body": "..."}`
- 全体所感: `{"body": "...", "scope": "review"}`

**本文が複数行になるため、stdin パイプではなく必ず Write ツールで一時ファイルを書いてから `--file` で渡すこと。** 生の改行を含む JSON をシェルの引用符で渡すと壊れる。一時ファイルは worktree の外（例: `/tmp` や実行環境のスクラッチディレクトリ）に置き、worktree に untracked なファイルを残さないこと。

```bash
crit comment --json --file <一時ファイルパス> --author 'Claude Code'
```

`line` はディスク上のファイルの行番号（1 始まり）であって、diff の行番号ではない。

指摘が 0 件の場合も、全体所感を `scope: "review"` で 1 件登録する。

登録後、`crit comments --all` で件数を確認する。0 件のまま先に進まないこと（ステップ2 が実行されていない、または review file がずれている可能性がある）。

### ステップ4: story 本体の生成

**`crit:crit-story` スキルは起動しないこと。** あのスキルの手順は `--pr` と `--refresh` を付けずに `crit story --prep` / `crit story --story-file` を実行するため、diff スコープが cwd/ブランチから再解決され、ステップ2 のスタブとは別の review file に story が入って、ステップ3 のコメントが孤立する。ここでは以下を自分で実行する。

1. **ガイドとスキーマを読む**

   ```bash
   crit story --guide
   ```

   解決済みの authoring guide と、出力すべき JSON のスキーマが `---` 区切りで出る。**JSON の構造と書き方の方針についてはこのガイドが唯一の正**で、本コマンドの記述より優先する。

   ただし **CLI の叩き方はここに書いてあるとおりにすること**。ガイドやスキルの例に `--pr` や `--refresh` の付かない `crit story` が出てきても、それに合わせてはならない（review file がずれてコメントが孤立する）。

2. **prep ファイルを書き出して読む**

   ```bash
   crit story --pr $ARGUMENTS --prep <prep の一時ファイルパス>
   ```

   コミットメッセージと全 hunk（各 hunk の `(file_path, old_start)` 付き）が書かれる。**Read ツールでこのファイルを読むこと。** 内容はプロンプトには埋め込まれない。ステップ2 と diff スコープを揃えるため、ここでも `--pr $ARGUMENTS` を付ける。

3. **story JSON を自分で書く**

   ガイドに従い、hunk をファイル単位ではなくテーマ単位でまとめ、**`prologue` / `chapters` / `support` の 3 つだけ**を持つ JSON オブジェクトを一時ファイルに Write する。`version` / `generated_at` / `agent` / `base_sha` / `head_sha` / `scope_fingerprint` / `coverage` は crit が埋めるので含めない。

4. **ingest する**

   ```bash
   crit story --pr $ARGUMENTS --story-file <story JSON の一時ファイルパス> --refresh
   ```

   `~/.crit.config.json` に `agent_cmd` は設定されていないため、bare の `crit story --refresh`（LLM 自動生成）は使えない。**`--story-file` で JSON を明示的に渡すこと。** ステップ2 のスタブが既にあるので `--refresh` は必須、diff スコープを揃えるため `--pr $ARGUMENTS` も必須。

   prep ファイルと story JSON はどちらも worktree の外に置き、worktree に untracked なファイルを残さないこと。

   exit 0 なら保存成功（ブラウザが開く）。exit 1 なら却下で、成否にかかわらず coverage レポートが JSON で stdout に出る。

   - `duplicated` が空でない → 同じ hunk を 2 つの章（または章と support）が取り合っている。所属を決めて ingest し直す。
   - exit 0 で `missing` が空でなく `auto_repaired: true` → crit が `support[]` に補完済み。必要なら意図した場所に置き直して再 ingest する。
   - 「diff changed since prep」系のエラー → `crit story --pr $ARGUMENTS --prep <path>` からやり直す。

**このコマンドは daemon 通知が 422 エラーで失敗することがある。ファイル自体は書き込まれていてもエラーが出るため、失敗表示だけで中断しないこと。** 実行後は必ず次で状態を確認する:

```bash
crit status --json
```

- `review_file` がステップ2 で作られたものと同じパスであること
- `review_file_exists: true` であること
- `crit comments --all` の件数がステップ3 の直後から減っていないこと

一致しない場合は、ステップ2〜4 の順序が守られていない可能性がある。story と comments が同じ review file を指しているかを再確認すること。

### ステップ5: 引き継ぎ

以下をユーザーに伝えて終了する。

- 一次レビューの指摘件数（🔴 / 🟡 の内訳）
- crit のブラウザが開いていること
- 最終レビューで追記したコメントは `crit push $ARGUMENTS` で GitHub PR に反映できること
- レビューが終わったら `git gtr rm review-$ARGUMENTS` で worktree を片付けること

### 補足: クリア操作を行う場合の注意

`crit story --clear` や `crit comment --clear` は、daemon 起動中だと「Cleared ...」という成功メッセージを返してもディスクの内容が更新されないことがある。**このメッセージを信用せず、`crit comments --all`（必要なら対象の review file を直接読む）で実際に消えたことを確認すること。**
