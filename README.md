[English](#english) | [日本語](#日本語)

<a name="日本語" herf="/README_ja.md"></a>


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

