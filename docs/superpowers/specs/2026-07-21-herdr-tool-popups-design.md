# herdr CLIツール・ポップアップ 設計

## 目的

herdr からキーバインドを入力すると、現在の作業ディレクトリで hunk または lazygit をポップアップ起動できるようにする。

## 変更内容

`home/.config/herdr/config.toml` に herdr 標準の command popup 設定を2件追加する。

- `prefix+ctrl+h`: `hunk`（説明: `run hunk`）
- `prefix+ctrl+g`: `lazygit`（説明: `run lazygit`）
- 両方の種別: `popup`
- 両方の幅: `80%`
- 両方の高さ: `80%`

既存の `[keys]` 設定、shell 設定、テーマ設定には変更を加えない。ラッパースクリプトや shell 経由の起動も追加しない。

## エラー時の挙動

`hunk` または `lazygit` が `PATH` 上に存在しない場合は、herdr の通常の command popup 起動エラーに任せる。dotfiles 側では追加のフォールバック処理を設けない。

## 検証

1. herdr が変更後の設定をエラーなく読み込めることを確認する。
2. herdr 上で `prefix+ctrl+h` を入力し、80% × 80% のポップアップ内に hunk が起動することを確認する。
3. herdr 上で `prefix+ctrl+g` を入力し、80% × 80% のポップアップ内に lazygit が起動することを確認する。
4. 各ポップアップ終了後、元のペインへ戻れることを確認する。
