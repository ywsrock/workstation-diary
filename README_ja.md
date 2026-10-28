<div align="center">

# 📓 WD — Workstation Diary

**ターミナルを、そのままノートに。**
アイデア・作業ログ・TODO を、シェルから離れずに Markdown で記録。

![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-4EAA25?logo=gnubash&logoColor=white)
![Markdown](https://img.shields.io/badge/notes-Markdown-000000?logo=markdown)
![fzf](https://img.shields.io/badge/works%20great%20with-fzf-blueviolet)
![rclone](https://img.shields.io/badge/backup-rclone-3F79AD)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

[English](README.md) | [日本語](README_ja.md)

</div>

---

```console
$ wd add "ログインバグ修正" 仕事 緊急    # 新しいノートをエディタで開く
$ wd recent                              # 直前の作業にすぐ戻る
$ wd grep "timeout" -f                   # 全ノートをあいまい検索＆ライブプレビュー
$ wd sync gdrive                         # Google Drive にまとめてバックアップ
```

## ✨ WD の魅力

- **手間ゼロ** — シェル関数ひとつだけ。デーモンもDBも専用アプリも不要。`wd add` ですぐ書き始められます。
- **ずっと使えるプレーンな Markdown** — ノートは YAML フロントマター付きの `.md` ファイル。grep も Git 管理も、Obsidian や VS Code で開くのも自由。ロックインなし。
- **すぐ見つかる** — 正規表現の全文検索、タグ検索、最近のノート。[fzf](https://github.com/junegunn/fzf) による対話的な選択と [bat](https://github.com/sharkdp/bat) のシンタックスハイライト付きプレビューに対応。
- **安全なバックアップ** — [rclone](https://rclone.org/) で Google Drive / AWS S3 へ送信。追加・更新のみで、リモートのファイルは決して削除しません。
- **環境を選ばない** — fzf がなければ番号選択メニュー、bat がなければ `head` で表示。そのまま動きます。

## 🚀 クイックスタート

```bash
# 1. クローン
git clone git@github.com:ywsrock/workstation-diary.git ~/workstation-diary

# 2. シェルに wd 関数を読み込む（~/.zshrc または ~/.bashrc）
echo 'source ~/workstation-diary/sh/wd.sh' >> ~/.zshrc

# 3. 再読み込みして最初のノートを作成
source ~/.zshrc
wd add "Hello WD" first
```

ノートはデフォルトで `~/notes` に保存されます（自動作成）。

> [!TIP]
> オプションのツールを入れると、さらに快適になります：
> ```bash
> brew install fzf bat rclone   # macOS
> ```

## 📝 ノートの中身

`wd add "ログインバグ修正" 仕事 緊急` を実行すると、一意な名前のファイルが作られます：

```
~/notes/20261028_142305_a1b2c3d4_ログインバグ修正.md
        └─日付─┘ └時刻┘ └ランダム┘ └─タイトル─┘
```

以下のフロントマターが書き込まれ、エディタ（`nvim` → `vim` → `nano` の順で最初に見つかったもの）で開きます：

```markdown
---
title: ログインバグ修正
date: 20261028
tags: 仕事 緊急
---

```

ファイル名が日時から始まるので、どのファイルブラウザでも時系列順に並びます。

## 🧭 コマンド一覧

| コマンド | 説明 |
| --- | --- |
| `wd add <名前> [タグ...]` | フロントマター付きのノートを作成して開く |
| `wd open [名前]` | ノートを開く（名前省略時は対話的に選択） |
| `wd list [キーワード]` | ノート一覧（内容で絞り込み可）から選んで開く |
| `wd recent [件数]` | 最近更新したノートから選んで開く（デフォルト: 5件） |
| `wd preview [名前]` | ノートの先頭50行を表示 |
| `wd search <正規表現>` | 全ノートを正規表現で検索（fzf があれば自動で使用） |
| `wd grep <キーワード> [-f]` | 大文字小文字を区別しない検索。`-f` で fzf を使用 |
| `wd tag [名前]` | ノートのタグを表示・編集 |
| `wd tag search <タグ>` | 指定タグを持つノートを検索 |
| `wd delete [名前]` | ノートを削除（確認あり） |
| `wd sync <gdrive\|s3>` | rclone でバックアップ（リモート側の削除なし） |
| `wd config` | 現在のノートディレクトリを表示 |
| `wd help [コマンド]` | ヘルプを表示（コマンド指定で詳細） |

> `[名前]` はファイルパスに対して大文字小文字を区別せずに部分一致します。`wd open ログイン` のようにタイトルの一部だけで OK です。

<details>
<summary><b>📖 コマンドの詳細と使用例</b></summary>

### `add`
```bash
wd add "会議メモ" 仕事 会議
```
タイトル「会議メモ」、タグ `仕事 会議` のノートを作成します。

### `open` / `preview` / `delete`
```bash
wd open "会議"        # 名前の一部で開く
wd open               # 対話的に選択
wd preview 会議       # 先頭50行を表示（bat があればハイライト付き）
wd delete "古いノート" # y/n で確認してから削除
```

### `list`
```bash
wd list                # すべてのノート
wd list プロジェクト   # 本文に「プロジェクト」を含むノートのみ
```

### `recent`
```bash
wd recent       # 直近5件
wd recent 10    # 直近10件
```

### `search` と `grep` の違い
```bash
wd search "TODO.*緊急"   # 正規表現・大文字小文字を区別、fzf があれば自動で使用
wd grep 重要             # 大文字小文字を区別しない、色付き出力
wd grep 重要 -f          # 同上を fzf で。該当行からプレビュー
```

### `tag`
```bash
wd tag "会議"          # 現在のタグを表示し、新しいタグを入力
wd tag search 仕事     # 「仕事」タグの付いたノートを一覧表示
```

</details>

## ☁️ rclone によるクラウドバックアップ

`wd sync` は `rclone copy --update` を実行し、**新規・更新されたノートだけをアップロード**します。リモート側のファイルは削除しません。このマシンからの一方向バックアップです。

| 送信先 | 必要な rclone リモート名 | 保存先 |
| --- | --- | --- |
| Google Drive | `gdrive` | `gdrive:WDNotes` |
| AWS S3 | `s3` | `s3:$WD_S3_BUCKET/notes` |

```bash
# 初回のみ: "gdrive"（または "s3"）という名前のリモートを作成
rclone config

# Google Drive
wd sync gdrive

# AWS S3
export WD_S3_BUCKET="my-bucket"
wd sync s3
```

## ⚙️ 設定

| 環境変数 | デフォルト | 説明 |
| --- | --- | --- |
| `WD_NOTES_DIR` | `$HOME/notes` | ノートの保存先 |
| `WD_S3_BUCKET` | — | `wd sync s3` で使う S3 バケット |

```bash
# ~/.zshrc
export WD_NOTES_DIR="$HOME/Dropbox/notes"
export WD_S3_BUCKET="my-bucket"
source ~/workstation-diary/sh/wd.sh
```

## 📦 動作要件

| ツール | 必須? | 用途 |
| --- | --- | --- |
| Bash または Zsh | ✅ | `wd` の実行 |
| `find`, `grep`, `sed` | ✅ | 一覧表示・検索 |
| `openssl` | ✅ | 一意なファイル名の生成 |
| `nvim` / `vim` / `nano` | ✅（いずれか） | ノートの編集 |
| [fzf](https://github.com/junegunn/fzf) | 任意 | 対話的なあいまい選択 |
| [bat](https://github.com/sharkdp/bat) | 任意 | ハイライト付きプレビュー |
| [rclone](https://rclone.org/) | 任意 | `wd sync` |

## 💡 Tips

- **日報:** `alias today='wd add "daily-$(date +%F)" daily'`
- **ノートをバージョン管理:** `$WD_NOTES_DIR` で `git init` すれば履歴を残せます。
- **共有フォルダ:** `WD_NOTES_DIR` を Dropbox / iCloud のフォルダに向ければ、複数端末からリアルタイムに使えます。

## 📄 ライセンス

[MIT](LICENSE) © ywsrock
