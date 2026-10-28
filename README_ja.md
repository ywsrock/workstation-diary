# WD (Workstation Diary)

[English](README.md) | [日本語](README_ja.md)

ターミナルからメモを書いたり探したりするための、小さなシェル関数です。

メモはひとつのディレクトリに置かれた普通の Markdown ファイルなので、好きなエディタで開いたり、grep したり、Git で管理したりできます。WD がやるのは、ファイル名を付ける、ヘッダーを書く、目的のメモにすぐ戻る、といった面倒な部分だけです。

```console
$ wd add "ログインバグ修正" 仕事 緊急
$ wd recent
$ wd grep timeout -f
$ wd sync gdrive
```

## インストール

```bash
git clone git@github.com:ywsrock/workstation-diary.git ~/workstation-diary
echo 'source ~/workstation-diary/sh/wd.sh' >> ~/.zshrc   # bash の場合は ~/.bashrc
source ~/.zshrc
```

メモはデフォルトで `~/notes` に保存されます。ディレクトリは初回実行時に作られます。

fzf、bat、rclone はなくても動きますが、fzf と bat があるとかなり使いやすくなります。

```bash
brew install fzf bat rclone
```

fzf がない場合は番号で選ぶメニューになり、bat がない場合はプレビューが普通のテキスト表示になります。

## メモの形式

`wd add "ログインバグ修正" 仕事 緊急` を実行すると、次のようなファイルができます。

```
~/notes/20261028_142305_a1b2c3d4_ログインバグ修正.md
```

ファイル名は「日付_時刻_ランダムな文字列_タイトル」です。日付から始まるので、普通に `ls` するだけで書いた順に並びます。

ファイルの先頭には簡単なヘッダーが入り、そのままエディタ（nvim、vim、nano のうち最初に見つかったもの）で開きます。

```markdown
---
title: ログインバグ修正
date: 20261028
tags: 仕事 緊急
---
```

## コマンド

| コマンド | 説明 |
| --- | --- |
| `wd add <名前> [タグ...]` | メモを作成して開く |
| `wd open [名前]` | メモを開く |
| `wd list [キーワード]` | メモを一覧表示（キーワードで絞り込み可）して開く |
| `wd recent [件数]` | 最近更新したメモから選んで開く（デフォルト 5 件） |
| `wd preview [名前]` | メモの先頭 50 行を表示 |
| `wd search <正規表現>` | 全メモを正規表現で検索 |
| `wd grep <キーワード> [-f]` | 大文字小文字を区別せずに検索。`-f` で fzf から選択 |
| `wd tag [名前]` | タグを表示・変更 |
| `wd tag search <タグ>` | タグでメモを探す |
| `wd delete [名前]` | メモを削除（確認あり） |
| `wd sync <gdrive\|s3>` | rclone でバックアップ |
| `wd config` | 保存先ディレクトリを表示 |
| `wd help [コマンド]` | ヘルプを表示 |

`[名前]` を取るコマンドは、タイトルの一部だけで大丈夫です（`wd open ログイン` など）。大文字小文字も区別しません。複数のメモが当てはまった場合は、どれを使うか聞かれます。名前を省略すると、全メモの一覧から選べます。

使用例:

```bash
wd open                    # 全メモから選ぶ
wd list プロジェクト       # 「プロジェクト」を含むメモ
wd recent 10               # 直近 10 件
wd search "TODO.*緊急"     # 正規表現（大文字小文字を区別）
wd grep 重要 -f            # fzf で選択、該当行からプレビュー
wd tag search 仕事         # 「仕事」タグの付いたメモ
```

## バックアップ

`wd sync` は `rclone copy --update` でメモをアップロードします。送られるのは新しいファイルと変更されたファイルだけで、リモート側のファイルが削除されることはありません。アップロードのみの一方向のバックアップで、リモートの変更を取り込むことはしません。

先に `rclone config` でリモートを設定しておいてください。リモート名は次のように決まっています。

| コマンド | rclone のリモート名 | アップロード先 |
| --- | --- | --- |
| `wd sync gdrive` | `gdrive` | `gdrive:WDNotes` |
| `wd sync s3` | `s3` | `s3:$WD_S3_BUCKET/notes` |

S3 を使う場合は、バケット名を設定します。

```bash
export WD_S3_BUCKET="my-bucket"
wd sync s3
```

## 設定

| 環境変数 | デフォルト | |
| --- | --- | --- |
| `WD_NOTES_DIR` | `$HOME/notes` | メモの保存先 |
| `WD_S3_BUCKET` | （なし） | `wd sync s3` で使うバケット |

シェルの設定ファイルで、`source` の行より前に書いてください。

```bash
export WD_NOTES_DIR="$HOME/Dropbox/notes"
source ~/workstation-diary/sh/wd.sh
```

## 動作環境

- Bash または Zsh
- `find`、`grep`、`sed`、`openssl`（macOS やたいていの Linux には最初から入っています）
- nvim、vim、nano のいずれか
- 任意: [fzf](https://github.com/junegunn/fzf)、[bat](https://github.com/sharkdp/bat)、[rclone](https://rclone.org/)

## Tips

日報用のエイリアスを作っておくと便利です。

```bash
alias today='wd add "daily-$(date +%F)" daily'
```

メモの履歴を残したい場合は、保存先ディレクトリで `git init` してください。複数のマシンで同時に使いたい場合は、`WD_NOTES_DIR` を Dropbox や iCloud のフォルダにすると簡単です。

## ライセンス

MIT ライセンスです。詳しくは [LICENSE](LICENSE) を見てください。
