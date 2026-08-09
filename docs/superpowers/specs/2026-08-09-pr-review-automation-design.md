# PR レビュー自動化 (`prv` + `/pr-code-review-with-crit`) 設計

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
- スラッシュコマンド `/pr-code-review-with-crit` を、dotfiles のユーザーレベル（`home/.claude/commands/`）と mento（`.claude/commands/`）の両方に追加する

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
 └─ herdr agent start → herdr agent prompt "/pr-code-review-with-crit <num>"
                                    │
                                    ▼
/pr-code-review-with-crit <num>                 ← スラッシュコマンド (dotfiles ユーザーレベル + mento)
 ├─ /pr-code-review <num>                       ← 既存スキル、無改変
 ├─ crit story --pr <num> --skip-llm --no-open  ← story スタブを先に作り review file を確定
 ├─ crit comment --json --file <tmp>            ← 指摘を同じ review file に一括登録
 └─ crit story --pr <num> --story-file <tmp> --refresh
                                                ← story 本体を生成・ingest、ブラウザが開く
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
   `herdr agent prompt "/pr-code-review-with-crit <番号>"` を投げる。

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

## コンポーネント 2: `/pr-code-review-with-crit` (スラッシュコマンド)

配置: **ほぼ同じ内容を 2 箇所に置く。**

1. `home/.claude/commands/pr-code-review-with-crit.md`（dotfiles・ユーザーレベル）
   `~/.claude` は dotfiles の `home/.claude` への symlink なので、全リポジトリ・全 worktree から見える。
2. `<mento>/.claude/commands/pr-code-review-with-crit.md`（mento・チーム共有）

**mento だけに置くことはできない。** `prv` が作る worktree は PR の head ブランチをチェックアウトするため、リポジトリ管理下のコマンドファイルはその worktree からは見えない。`develop` にマージしても、それ以前に切られた既存の PR ブランチ（=現在開いている PR のすべて）には反映されないので、この問題は解消しない。ユーザーレベルの方が、今開いている PR に対する唯一の供給経路になる。

**dotfiles だけに置くのも選ばなかった。** チームで使えるようにするため mento にも入れる。将来 `develop` から切られた PR では、リポジトリ側のコピーが自然に使われる。

二重管理になるので、**crit の手順そのものは同一に保ち、片方を直したらもう片方も直すこと**。

ただし mento 側はチーム向けなので、意図的に次を落としてある。

- dotfiles 側の冒頭にある同期の注意書き（チームには関係のない事情）
- 個人ワークフローへの言及 — `prv` / `git gtr` / dotfiles のパス / この機体で `agent_cmd` が未設定であること。
  「PR のブランチをチェックアウトした作業ツリーで実行する」「`--story-file` で明示的に渡せば `agent_cmd` の
  設定に依存しない」といった、環境に依存しない書き方に置き換えている。

worktree の中で実行される前提であることは変わらない。`/pr-code-review` が `backend/mento-backend/CLAUDE.md` などリポジトリ相対のガイドラインを読むため、cwd が mento のチェックアウト内であることが必須条件になる。ユーザーレベルに置くとどのリポジトリからでも起動できてしまうので、コマンド側の先頭で次を検査して弾く。

- origin の URL が `ugokuinc/mento` であること
- カレントブランチが `gh pr view <番号> --json headRefName` の結果と一致すること

ディレクトリ名（`mento-worktrees/review-<番号>`）では判定しない。`crit comment` は cwd とブランチから review を解決するため、ディレクトリ名が合っていてもブランチが差し替わっていれば別の review file に書き込まれてしまう。

### 手順

1. **一次レビュー** — 既存の `pr-code-review` スキルを PR 番号付きで実行する。
   このスキルはレビュー結果を構造化テキストで返す。
2. **story スタブの生成** — `crit story --pr <番号> --skip-llm --no-open` を先に実行し、review file を確定させる。
   `crit comment` は cwd とブランチから review を解決するのに対し `crit story --pr` は diff スコープから
   新しい review file を作るため、後続の `crit comment` を同じファイルに書き込ませるにはこの手順が
   必ず先に必要になる（根拠は下記「review file のスコープ問題」の実測結果）。
3. **crit への登録** — 指摘を crit のコメント JSON に変換し、Write ツールで一時ファイルに書いてから
   `crit comment --json --file <tmp> --author 'Claude Code'` で一括投入する。
   - 行単位の指摘 → `{"file": ..., "line": ..., "body": ...}`
   - ファイル全体の指摘 → `{"path": ..., "body": ...}`
   - 全体所感 → `{"body": ..., "scope": "review"}`
   - 本文が複数行になるため、stdin パイプではなく必ず `--file` を使う
4. **story 本体の生成** — `crit story --guide` でスキーマを、`crit story --pr <番号> --prep <tmp>` で
   prep を得て、エージェント自身が story JSON（`prologue` / `chapters` / `support` のみ）を書き、
   `crit story --pr <番号> --story-file <tmp> --refresh` で ingest する。ブラウザが開く。
   `~/.crit.config.json` に `agent_cmd` を設定していないため、CLI 単体の `crit story` 自動生成には依存しない。
   **`crit:crit-story` スキルには委譲しない。** あのスキルの手順は `crit story --prep` / `crit story --story-file`
   を `--pr` も `--refresh` も付けずに実行するため、diff スコープが cwd/ブランチから再解決され、
   手順 2 のスタブとは別の review file に story が入って手順 3 のコメントが孤立する
   （下記「review file のスコープ問題」で防ごうとしている事象そのもの）。
5. **引き継ぎ** — ブラウザで最終レビューし、追記したコメントを
   `crit push <番号>` で GitHub PR に反映する、と案内して終了する。

### review file のスコープ問題

`crit comment` は cwd とブランチから review を解決し、`crit story` は診断対象の diff スコープから review を作る。
この 2 つが別の review file になるとコメントが story 側に出てこない。実測の結果、順序を入れ替えないと
必ず食い違うことが分かったため、コンポーネント 2 の手順 2〜4 は次の順序で固定する（コメント先行を
実行時の条件分岐で判定する設計ではない）:

1. `crit story --pr <番号> --skip-llm --no-open` で review をスタブ生成する
2. `crit comment --json --file <tmp>` でコメントを載せる
3. `crit story --pr <番号> --story-file <tmp> --refresh` で story 本体を ingest する

**実測結果（2026-08-09、`review-4269` worktree で検証）**: `crit comment` を先に実行すると
review file は `~/.crit/reviews/495449ca40c8/review.json` に書かれ、続けて
`crit story --pr 4269 --skip-llm --no-open` を実行すると別の review file
（`~/.crit/reviews/9a7fae97b015/review.json`）が新規に作られた。`crit status --json` の
`review_file` がステップ間で変わり、`crit comments --all` はコメント 0 件（先行コメントは
別ファイルに孤立）。逆に story を先に作った後で `crit comment` を打つと同じ review file に
書き込まれ、`crit story --refresh` を挟んでもコメントは保持された。よって採用順序は
**「story スタブ先行」**（`crit story --pr --skip-llm --no-open` → `crit comment` →
`crit story --pr --story-file --refresh`）に決定する。

**運用上の注意（実測中に確認した crit の挙動）**:

- `crit story --refresh` の実行時に `daemon returned 422 Unprocessable Entity` という
  daemon 通知失敗が発生した。ファイル自体は書き込まれていたが、daemon 起動中は
  in-memory state とディスクの内容がズレることがある。`--refresh` の直後は必ず
  `crit status --json` で `review_file` がステップ 1 と同じパスであること・
  `review_file_exists: true` であることを確認する。
- `crit story --clear` / `crit comment --clear` は、daemon が起動中だと
  「Cleared ...」という成功メッセージを返すのにディスクの内容が更新されない事象が
  あった。クリア操作の成否はこのメッセージを信用せず、`crit comments --all`
  （必要なら対象の review file を直接読む）で確認する。

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

## 通し実行の結果（2026-08-09）

`prv` から `/pr-code-review-with-crit` までを実際に通した結果、**crit のブラウザに story と一次レビューのコメントの両方が表示された。**
「story スタブ先行」の順序が本番でも成立することを確認できた。この順序を外すとコメントが孤立して
機能そのものが無意味になるため、ここが本設計で唯一の必須確認だった。

通す過程で 2 件を修正している。

- `prv` が `agent_pane_busy` で Claude を起動できなかった。作りたてのワークスペースのペインは
  fish が `config.fish` を読んでいる間もプロセスグループ判定を通ってしまうため。`agent start` を
  リトライする形にした（詳細は `prv` のコメント）。
- エージェントを `--dangerously-skip-permissions` 付きで起動するようにした。`pr-code-review` は
  サブエージェントを多数 dispatch するため、素の `claude` だと承認プロンプトで止まる。

未確認: `crit push <番号>` による GitHub への反映と、`crit story --refresh` の 422 が
「エラーは出るがファイルは書かれる」で済むかの再現性（実測は 1 回のみ）。

## テスト方針

自動テストは書かない。fish 関数と CLI の結線が主体で、実行して確かめるほうが速く確実なため。

代わりに以下を手動で確認する。

1. `prv` で PR を選び、worktree が `review-<番号>` で作られ、herdr ワークスペースが開き、Claude に `/pr-code-review-with-crit <番号>` が渡ること
2. 同じ PR に対して `prv` を再実行し、worktree が二重に作られないこと
3. `/pr-code-review-with-crit` が最後まで走り、crit のブラウザに **story と一次レビューのコメントの両方**が出ること
4. ブラウザで足したコメントが `crit push <番号>` で GitHub PR に載ること
5. mento 以外のリポジトリで `prv` を実行し、そのリポジトリの PR が候補に出ること

## 判断の記録

- **`prv` を mento 専用にするか汎用にするか** → 汎用にする。`gh` が cwd からリポジトリを解決するので追加コストがない。
  ただし `/pr-code-review-with-crit` は mento 専用（origin と PR の head ブランチを検査して弾く）なので、
  他リポジトリでは worktree を開いてコマンドを投入した時点で、コマンド側の検査に引っかかって止まる。これは許容する。
- **`/pr-code-review-with-crit` をどこに置くか** → dotfiles のユーザーレベルと mento の両方。
  `prv` の worktree は PR の head ブランチをチェックアウトするので、mento だけに置くと
  既存のどの PR からも見えない。一方でチーム共有もしたいので mento にも入れる。
  二重管理は許容する。詳細はコンポーネント 2 の配置を参照。
- **コマンド名** → `pr-code-review-with-crit`。mento の既存スキル `pr-code-review` と紛れず、
  crit を使う点が名前に出る。当初は `/review-pr` だった。
- **Draft PR を候補に含めるか** → 含める。fzf の一覧に `[Draft]` を出して判断は人間に任せる。
