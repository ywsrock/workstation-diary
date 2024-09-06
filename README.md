# WD (Workstation Diary)

[English](#english) | [日本語](#日本語)

<a name="english"></a>
## English

WD is a command-line tool for managing and organizing your notes efficiently. It provides a simple interface for creating, editing, searching, and managing markdown notes directly from your terminal.

### Features

- Create and edit notes with automatic timestamps and tags
- List and search notes with interactive selection
- Delete notes with confirmation
- Preview note contents
- Search notes by content or tags
- Configure notes directory through environment variables
- Support for fzf for enhanced file selection (if installed)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/wd.git
   ```

2. Add the following line to your `~/.bashrc` or `~/.zshrc`:
   ```bash
   source /path/to/wd.sh
   ```

3. Reload your shell configuration:
   ```
   source ~/.bashrc  # or source ~/.zshrc
   ```

4. (Optional) Set a custom notes directory by adding the following line to your shell configuration:
   ```bash
   export WD_NOTES_DIR="/path/to/your/notes/directory"
   ```

### Usage

WD provides several commands for managing your notes. Here's a quick overview:

```
wd <command> [args]
```

#### Commands

- `add <note_name> [tags]`: Add a new note
- `list [keyword]`: List all notes or search by keyword, then select to open
- `delete [note_name]`: Delete a note (interactive selection if no name provided)
- `open [note_name]`: Open a note (interactive selection if no name provided)
- `search <regex_pattern>`: Search within notes using regex
- `grep <keyword> [-f]`: Grep for keyword in all notes (use -f for fzf)
- `preview [note_name]`: Preview a note (interactive selection if no name provided)
- `tag [note_name]`: View or edit tags of a note (interactive selection if no name provided)
- `tag search <tag_name>`: Search notes by tag
- `recent [count]`: Show and select from recent notes (default: 5)
- `config`: Show current configuration
- `help`: Show help message

### Detailed Command Descriptions

#### add

Create a new note with a given name and optional tags.

```
wd add <note_name> [tags]
```

Example:
```
wd add "My New Note" work important
```

This creates a new note with the title "My New Note" and tags "work" and "important".

#### list

List all notes or search by keyword. If a keyword is provided, it will filter the notes. You can then select a note to open.

```
wd list [keyword]
```

Example:
```
wd list
wd list project
```

#### delete

Delete a note. If no name is provided, it will prompt you to select a note to delete.

```
wd delete [note_name]
```

Example:
```
wd delete "My Old Note"
```

#### open

Open a note for editing. If no name is provided, it will prompt you to select a note to open.

```
wd open [note_name]
```

Example:
```
wd open "My Note"
```

#### search

Search within notes using a regex pattern.

```
wd search <regex_pattern>
```

Example:
```
wd search "TODO.*urgent"
```

#### grep

Search for a keyword in all notes. Use the `-f` flag to use fzf for interactive selection (if fzf is installed).

```
wd grep <keyword> [-f]
```

Example:
```
wd grep important -f
```

#### preview

Preview the contents of a note. If no name is provided, it will prompt you to select a note to preview.

```
wd preview [note_name]
```

Example:
```
wd preview "My Note"
```

#### tag

View or edit tags of a note. If no name is provided, it will prompt you to select a note.

```
wd tag [note_name]
```

Example:
```
wd tag "My Note"
```

#### tag search

Search notes by tag.

```
wd tag search <tag_name>
```

Example:
```
wd tag search work
```

#### recent

Show and select from recent notes. You can specify the number of recent notes to show (default is 5).

```
wd recent [count]
```

Example:
```
wd recent 10
```

#### config

Show the current configuration, including the notes directory.

```
wd config
```

#### help

Display the help message with a list of all available commands.

```
wd help
```

### Configuration

You can set a custom notes directory by setting the `WD_NOTES_DIR` environment variable:

```bash
export WD_NOTES_DIR="/path/to/your/notes/directory"
```

If not set, WD will use `$HOME/notes` as the default directory.

### Dependencies

- Bash or Zsh shell
- Standard Unix utilities (find, grep, sed, etc.)
- (Optional) fzf for enhanced file selection
- (Optional) bat for improved file previews



---

<a name="日本語"></a>
## 日本語

WDは、ノートを効率的に管理・整理するためのコマンドラインツールです。ターミナルから直接マークダウンノートの作成、編集、検索、管理を行うためのシンプルなインターフェースを提供します。

### 特徴

- タイムスタンプとタグを自動付与してノートを作成・編集
- 対話的な選択によるノートの一覧表示と検索
- 確認プロセス付きのノート削除機能
- ノート内容のプレビュー機能
- 内容やタグによるノート検索
- 環境変数を通じたノートディレクトリの設定
- fzf（インストールされている場合）を使用した高度なファイル選択機能

### インストール方法

1. リポジトリをクローンします：
   ```
   git clone https://github.com/yourusername/wd.git
   ```

2. 以下の行を `~/.bashrc` または `~/.zshrc` に追加します：
   ```bash
   source /path/to/wd.sh
   ```

3. シェルの設定を再読み込みします：
   ```
   source ~/.bashrc  # または source ~/.zshrc
   ```

4. （オプション）カスタムノートディレクトリを設定する場合は、以下の行をシェル設定に追加します：
   ```bash
   export WD_NOTES_DIR="/path/to/your/notes/directory"
   ```

### 使用方法

WDは、ノート管理のための複数のコマンドを提供します。基本的な使い方は以下の通りです：

```
wd <コマンド> [引数]
```

#### コマンド一覧

- `add <ノート名> [タグ]`: 新しいノートを追加
- `list [キーワード]`: 全ノートの一覧表示またはキーワードで検索し、選択して開く
- `delete [ノート名]`: ノートを削除（名前が指定されない場合は対話的に選択）
- `open [ノート名]`: ノートを開く（名前が指定されない場合は対話的に選択）
- `search <正規表現パターン>`: 正規表現を使用してノート内を検索
- `grep <キーワード> [-f]`: 全ノート内でキーワードを検索（-fオプションでfzfを使用）
- `preview [ノート名]`: ノートのプレビュー（名前が指定されない場合は対話的に選択）
- `tag [ノート名]`: ノートのタグを表示・編集（名前が指定されない場合は対話的に選択）
- `tag search <タグ名>`: タグでノートを検索
- `recent [数]`: 最近のノートを表示・選択（デフォルトは5件）
- `config`: 現在の設定を表示
- `help`: ヘルプメッセージを表示

### 詳細なコマンド説明

#### add

指定した名前と任意のタグで新しいノートを作成します。

```
wd add <ノート名> [タグ]
```

例：
```
wd add "新しいノート" 仕事 重要
```

これにより、"新しいノート"というタイトルで、"仕事"と"重要"というタグを持つ新しいノートが作成されます。

#### list

全ノートの一覧を表示するか、キーワードで検索します。キーワードが指定された場合、ノートをフィルタリングします。その後、ノートを選択して開くことができます。

```
wd list [キーワード]
```

例：
```
wd list
wd list プロジェクト
```

#### delete

ノートを削除します。名前が指定されない場合、削除するノートを選択するよう促されます。

```
wd delete [ノート名]
```

例：
```
wd delete "古いノート"
```

#### open

ノートを開いて編集します。名前が指定されない場合、開くノートを選択するよう促されます。

```
wd open [ノート名]
```

例：
```
wd open "マイノート"
```

#### search

正規表現パターンを使用してノート内を検索します。

```
wd search <正規表現パターン>
```

例：
```
wd search "TODO.*緊急"
```

#### grep

全ノート内でキーワードを検索します。`-f`フラグを使用すると、fzfを使用して対話的に選択できます（fzfがインストールされている場合）。

```
wd grep <キーワード> [-f]
```

例：
```
wd grep 重要 -f
```

#### preview

ノートの内容をプレビューします。名前が指定されない場合、プレビューするノートを選択するよう促されます。

```
wd preview [ノート名]
```

例：
```
wd preview "マイノート"
```

#### tag

ノートのタグを表示または編集します。名前が指定されない場合、ノートを選択するよう促されます。

```
wd tag [ノート名]
```

例：
```
wd tag "マイノート"
```

#### tag search

タグでノートを検索します。

```
wd tag search <タグ名>
```

例：
```
wd tag search 仕事
```

#### recent

最近のノートを表示し、選択できるようにします。表示する最近のノートの数を指定できます（デフォルトは5件）。

```
wd recent [数]
```

例：
```
wd recent 10
```

#### config

現在の設定（ノートディレクトリを含む）を表示します。

```
wd config
```

#### help

利用可能な全コマンドのリストを含むヘルプメッセージを表示します。

```
wd help
```

### 設定

カスタムノートディレクトリを設定するには、`WD_NOTES_DIR`環境変数を設定します：

```bash
export WD_NOTES_DIR="/path/to/your/notes/directory"
```

設定されていない場合、WDはデフォルトディレクトリとして`$HOME/notes`を使用します。

### 依存関係

- BashまたはZshシェル
- 標準Unixユーティリティ（find、grep、sedなど）
- （オプション）高度なファイル選択のためのfzf
- （オプション）改善されたファイルプレビューのためのbat


