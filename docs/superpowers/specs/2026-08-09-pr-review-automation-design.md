# PR レビュー自動化 (`prv` + `/review-pr`) 設計

## 背景と目的

GitHub でレビュー依頼された PR を処理する流れが、今は完全に手作業になっている。

1. GitHub / 通知でレビュー依頼に気づく
2. `git gtr new` で worktree を作る（既存運用の命名は `review-<PR番号>`）
3. herdr でワークスペースを開き、Claude を起動する
4. `/pr-code-review` で一次レビューを回す
5. 指摘を crit に載せ、`crit story` で最終レビューをする

このうち 1〜4 は機械的で、判断が要るのは 5 の最終レビューだけ。
本設計は **「PR を選ぶ」から「crit story がブラウザで開くまで」を 1 コマンドにまとめる**。

story を読んで良し悪しを決める工程は人間の仕事なので、自動化の対象外とする。

## スコープ

対象:

- dotfiles に fish 関数 `prv` を追加する
- mento リポジトリにスラッシュコマンド `/review-pr` を追加する

対象外:

- 新着 PR のポーリングと通知（pull 型の運用を維持する）
- クラウド上でのスケジュール実行（`gtr` / `crit` / `herdr` がすべてローカル依存のため実現できない）
- 既存の `/pr-code-review` スキルの変更（無改変で流用する）

## 全体の流れ

```
prv                              ← fish 関数 (dotfiles)
 ├─ gh pr list --search "review-requested:@me" → fzf で選択
 ├─ git gtr new <headRef> --track remote --folder review-<num> --yes
 ├─ herdr worktree open --path <WT> --label review-<num> --focus
 └─ herdr agent start → herdr agent prompt "/review-pr <num>"
                                    │
                                    ▼
/review-pr <num>                 ← スラッシュコマンド (mento)
 ├─ /pr-code-review <num>        ← 既存スキル、無改変
 ├─ crit comment --json --file <tmp>   ← 指摘を crit に一括登録
 └─ /crit-story                  ← story を生成・ingest、ブラウザが開く
                                    │
                                    ▼
                       人間が最終レビュー → crit push <num>
```

## コンポーネント 1: `prv` (fish 関数)

配置: `home/.config/fish/config.fish`（`prj` / `wtn` の直後）

### インターフェース

```fish
prv [query]
```

`query` は fzf の初期クエリ。`prj` の `--query` と同じ扱い。

### 責務

1. **PR の選択** — カレントディレクトリの git リポジトリを対象に
   `gh pr list --search "review-requested:@me" --json number,title,author,headRefName,isDraft`
   を実行し、`<番号> <タイトル> (<author>)` の形で fzf に流す。
   `-R` は指定しない（`gh` が cwd から解決するので mento 以外でも使える）。
2. **worktree の用意** — `review-<番号>` が既にあれば作成をスキップし、無ければ
   `git gtr new <headRefName> --track remote --folder review-<番号> --yes` で作る。
3. **herdr ワークスペース** — `herdr worktree open --cwd $PWD --path <WT_PATH> --label review-<番号> --focus`
4. **エージェント起動** — `herdr agent start` でペインに Claude を起動し、
   `herdr agent prompt "/review-pr <番号>"` を投げる。

### 冪等性

**`review-<番号>` worktree の存在を「着手済み」マーカーとする。** 状態ファイルは持たない。
同じ PR に対して `prv` を再実行した場合は worktree 作成を飛ばし、既存ワークスペースを focus するだけで終わる（エージェントの再起動もしない）。
レビューを終えたら `git gtr rm review-<番号>` で片付ける。これが唯一の「完了」操作。

### エラー処理

- fzf で何も選ばれなかった場合は何もせず終了する（`prj` と同じ）
- `gh pr list` が 0 件なら「レビュー依頼はありません」と出して終了する
- `git gtr new` が失敗したら以降を実行せずに終了する（`wtn` と同じく `; or return`）
- herdr サーバが起動していない場合は `prj` と同じ起動待ちロジックを使う。
  この処理は `prj` と `prv` で重複するので `__ensure_herdr_server` に切り出す。

## コンポーネント 2: `/review-pr` (スラッシュコマンド)

配置: `<mento>/.claude/commands/review-pr.md`

worktree の中で実行される前提。`/pr-code-review` が `backend/mento-backend/CLAUDE.md` などリポジトリ相対のガイドラインを読むため、cwd が worktree 内であることが必須条件になる。

### 手順

1. **一次レビュー** — 既存の `pr-code-review` スキルを PR 番号付きで実行する。
   このスキルはレビュー結果を構造化テキストで返す。
2. **crit への登録** — 指摘を crit のコメント JSON に変換し、Write ツールで一時ファイルに書いてから
   `crit comment --json --file <tmp> --author 'Claude Code'` で一括投入する。
   - 行単位の指摘 → `{"file": ..., "line": ..., "body": ...}`
   - ファイル全体の指摘 → `{"path": ..., "body": ...}`
   - 全体所感 → `{"body": ..., "scope": "review"}`
   - 本文が複数行になるため、stdin パイプではなく必ず `--file` を使う
3. **story の生成** — `crit:crit-story` スキルを起動する。
   story JSON を書いて ingest し、ブラウザが開く。
   `~/.crit.config.json` に `agent_cmd` を設定していないため、CLI 単体の `crit story` 自動生成には依存しない。
4. **引き継ぎ** — ブラウザで最終レビューし、追記したコメントを
   `crit push <番号>` で GitHub PR に反映する、と案内して終了する。

### review file のスコープ問題

`crit comment` は cwd とブランチから review を解決し、`crit story` は診断対象の diff スコープから review を作る。
この 2 つが別の review file になるとコメントが story 側に出てこない。

ステップ 2 の直後に `crit status --json` で解決先を確認し、ステップ 3 の結果と一致することを検証する。
一致しない場合は順序を次のように入れ替える:

1. `crit story --pr <番号> --skip-llm --no-open` で review をスタブ生成する
2. `crit comment --json --file <tmp>` でコメントを載せる
3. `crit story --refresh` で story 本体を生成する

どちらの順序になるかは実装時に実測して決める。**推測で片方に決め打ちしない。**

## 検証済みの前提

実装前に実測で確認した事項。

| 項目 | 結果 |
|---|---|
| `gh pr list --search "review-requested:@me"` | 動作。mento で 10 件返る |
| 既存リモートブランチからの worktree 作成 | `git gtr new <headRef> --track remote --folder review-4269 --yes` で成功。upstream が `origin/<headRef>` に設定される |
| `git gtr go` の出力ストリーム | パスは stdout、`Worktree:` / `Branch:` の装飾行は stderr。`set WT_PATH (git gtr go ...)` がそのまま使える |
| `crit comment --json --file` | `crit:crit-cli` に仕様あり。1 プロセス 1 書き込みで原子的 |
| herdr のエージェント起動 | `herdr agent start` / `herdr agent prompt` が存在する |
| `~/.crit.config.json` | 存在しない。`agent_cmd` 未設定 |
| mento の `.gtrconfig` | `defaultbranch=develop`、`.env` 等のコピー設定済み。追加設定は不要 |

検証で作った `review-4269` worktree が残っている。実装時のテスト対象として使うか、`git gtr rm review-4269` で削除する。

## テスト方針

自動テストは書かない。fish 関数と CLI の結線が主体で、実行して確かめるほうが速く確実なため。

代わりに以下を手動で確認する。

1. `prv` で PR を選び、worktree が `review-<番号>` で作られ、herdr ワークスペースが開き、Claude に `/review-pr <番号>` が渡ること
2. 同じ PR に対して `prv` を再実行し、worktree が二重に作られないこと
3. `/review-pr` が最後まで走り、crit のブラウザに **story と一次レビューのコメントの両方**が出ること
4. ブラウザで足したコメントが `crit push <番号>` で GitHub PR に載ること
5. mento 以外のリポジトリで `prv` を実行し、そのリポジトリの PR が候補に出ること

## 判断の記録

- **`prv` を mento 専用にするか汎用にするか** → 汎用にする。`gh` が cwd からリポジトリを解決するので追加コストがない。
  ただし `/review-pr` は mento にしか無いので、他リポジトリでは worktree を開いた時点で止まる。これは許容する。
- **Draft PR を候補に含めるか** → 含める。fzf の一覧に `[Draft]` を出して判断は人間に任せる。
