# Herdr resume 時の権限スキップ設計

## 目的

Herdr がサーバー再起動後に Claude Code または Codex の native session を resume するとき、既存の `cc` / `co` alias と同じ権限スキップオプションを適用する。

Herdr 0.7.4 は resume コマンドを `claude --resume <session-id>` または `codex resume <session-id>` として内部で固定生成する。実行名を Herdr の設定で上書きする機能はないため、Herdr が起動する対話 Fish 上で対象コマンドだけをラップする。

## 対象範囲

- `home/.config/fish/config.fish` に `claude` と `codex` の Fish 関数を追加する。
- `HERDR_ENV` が設定され、引数が native resume の形式に一致し、かつ同じ権限スキップオプションが未指定の場合だけオプションを追加する。
- 既存の `cc` / `co` alias は変更しない。
- Herdr 本体、Herdr の session データ、公式 integration は変更しない。

## コマンド変換

Claude Code は、Herdr 内で引数に `--resume` を含み、`--dangerously-skip-permissions` が未指定の場合に次のように変換する。

```text
claude --resume <session-id>
→ command claude --dangerously-skip-permissions --resume <session-id>
```

Codex は、Herdr 内で先頭引数が `resume` で、`--dangerously-bypass-approvals-and-sandbox` が未指定の場合に次のように変換する。

```text
codex resume <session-id>
→ command codex --dangerously-bypass-approvals-and-sandbox resume <session-id>
```

関数内では `command claude` / `command codex` を使い、同名の Fish 関数を再帰呼び出ししない。

## 通常起動と alias の扱い

- Herdr 外の `claude` / `codex` は追加オプションなしで実体へ委譲する。
- Herdr 内でも resume 以外の `claude` / `codex` は追加オプションなしで実体へ委譲する。
- `cc` / `co` は従来どおり、起動場所や引数にかかわらず権限スキップオプションを付ける。
- `cc` / `co` から同名ラッパーを経由した場合は、既に付与されたオプションを検出し、一度だけ実体へ渡す。

## エラー処理

引数や session ID は変更せず、そのまま実コマンドへ渡す。実体が `PATH` にない場合や resume に失敗した場合は、Claude Code、Codex、Herdr の既存エラー表示に任せ、独自のフォールバックや再試行は追加しない。

## 検証

実コマンドを呼び出さないモック executable と一時的な `PATH` を使い、Fish 関数が渡す引数を確認する。

1. `HERDR_ENV=1` で Claude Code resume を呼ぶと `--dangerously-skip-permissions` が一度だけ追加される。
2. `HERDR_ENV=1` で Codex resume を呼ぶと `--dangerously-bypass-approvals-and-sandbox` が一度だけ追加される。
3. Herdr 内の resume 以外と Herdr 外の canonical command にはオプションが追加されない。
4. resume 引数を付けた `cc` / `co` を含め、既存 alias は従来のオプションを重複させず、受け取った引数を保持する。
5. `fish -n home/.config/fish/config.fish` が成功する。

実環境では設定を再読み込みした後、次回の Herdr server restart による native resume で適用される。既存セッションを検証目的で停止・再起動する操作は自動では行わない。
