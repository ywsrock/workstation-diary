<div align="center">

# 📓 WD — Workstation Diary

**Your terminal is your notebook.**
Capture ideas, logs, and TODOs as Markdown — without ever leaving the shell.

![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-4EAA25?logo=gnubash&logoColor=white)
![Markdown](https://img.shields.io/badge/notes-Markdown-000000?logo=markdown)
![fzf](https://img.shields.io/badge/works%20great%20with-fzf-blueviolet)
![rclone](https://img.shields.io/badge/backup-rclone-3F79AD)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

[English](README.md) | [日本語](README_ja.md)

</div>

---

```console
$ wd add "Fix login bug" work urgent     # opens a new note in your editor
$ wd recent                              # jump back into what you were doing
$ wd grep "timeout" -f                   # fuzzy-search every note, with live preview
$ wd sync gdrive                         # back it all up to Google Drive
```

## ✨ Why WD?

- **Zero friction** — one shell function, no daemon, no database, no app to open. `wd add` and you're writing.
- **Plain Markdown, forever** — every note is a `.md` file with YAML front matter. Grep it, version it, open it in Obsidian or VS Code. No lock-in.
- **Find anything fast** — full-text regex search, tag search, and recent notes, with an interactive [fzf](https://github.com/junegunn/fzf) picker and [bat](https://github.com/sharkdp/bat) syntax-highlighted previews.
- **Safe backups** — push notes to Google Drive or AWS S3 via [rclone](https://rclone.org/). Sync only adds or updates; it never deletes anything on the remote.
- **Degrades gracefully** — no fzf? You get a numbered `select` menu. No bat? Plain `head`. It just works.

## 🚀 Quick Start

```bash
# 1. Clone
git clone git@github.com:ywsrock/workstation-diary.git ~/workstation-diary

# 2. Load the wd function in your shell (~/.zshrc or ~/.bashrc)
echo 'source ~/workstation-diary/sh/wd.sh' >> ~/.zshrc

# 3. Reload and write your first note
source ~/.zshrc
wd add "Hello WD" first
```

Notes are stored in `~/notes` by default (created automatically).

> [!TIP]
> For the best experience, install the optional tools:
> ```bash
> brew install fzf bat rclone   # macOS
> ```

## 📝 What a Note Looks Like

`wd add "Fix login bug" work urgent` creates a uniquely named file:

```
~/notes/20261028_142305_a1b2c3d4_Fix login bug.md
        └─date─┘ └time┘ └random┘ └──title───┘
```

with this front matter, then opens it in your editor (`nvim` → `vim` → `nano`, whichever is found first):

```markdown
---
title: Fix login bug
date: 20261028
tags: work urgent
---

```

Because the date and time lead the filename, notes sort chronologically in any file browser.

## 🧭 Commands

| Command | What it does |
| --- | --- |
| `wd add <name> [tags...]` | Create a new note with front matter and open it |
| `wd open [name]` | Open a note — pick interactively if no name given |
| `wd list [keyword]` | List notes (optionally filtered by content) and open one |
| `wd recent [count]` | Pick from the most recently modified notes (default: 5) |
| `wd preview [name]` | Show the first 50 lines of a note |
| `wd search <regex>` | Regex search across all notes (fzf picker if installed) |
| `wd grep <keyword> [-f]` | Case-insensitive keyword search; `-f` for fzf |
| `wd tag [name]` | View or edit a note's tags |
| `wd tag search <tag>` | Find notes with a given tag |
| `wd delete [name]` | Delete a note (asks for confirmation) |
| `wd sync <gdrive\|s3>` | Back up notes with rclone (no remote deletions) |
| `wd config` | Show the current notes directory |
| `wd help [command]` | Show help (or details for one command) |

> `[name]` matches case-insensitively against the file path, so a partial title like `wd open login` is enough.

<details>
<summary><b>📖 Command details & examples</b></summary>

### `add`
```bash
wd add "Meeting notes" work meeting
```
Creates a note titled "Meeting notes" tagged `work meeting`.

### `open` / `preview` / `delete`
```bash
wd open "Meeting"     # open by partial name
wd open               # interactive picker
wd preview Meeting    # first 50 lines (bat-highlighted if available)
wd delete "Old note"  # asks y/n before removing
```

### `list`
```bash
wd list            # all notes
wd list project    # only notes whose content contains "project"
```

### `recent`
```bash
wd recent       # last 5
wd recent 10    # last 10
```

### `search` vs `grep`
```bash
wd search "TODO.*urgent"   # regex, case-sensitive, fzf automatically if installed
wd grep important          # case-insensitive, colored output
wd grep important -f       # same, but in fzf with preview at the matching line
```

### `tag`
```bash
wd tag "Meeting"      # shows current tags, prompts for new ones
wd tag search work    # list every note tagged "work"
```

</details>

## ☁️ Cloud Backup with rclone

`wd sync` runs `rclone copy --update`, which **uploads new and changed notes only** and never deletes files on the remote. It is a one-way backup from this machine.

| Target | Required rclone remote name | Destination |
| --- | --- | --- |
| Google Drive | `gdrive` | `gdrive:WDNotes` |
| AWS S3 | `s3` | `s3:$WD_S3_BUCKET/notes` |

```bash
# One-time setup: create a remote named "gdrive" (or "s3")
rclone config

# Google Drive
wd sync gdrive

# AWS S3
export WD_S3_BUCKET="my-bucket"
wd sync s3
```

## ⚙️ Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `WD_NOTES_DIR` | `$HOME/notes` | Where notes are stored |
| `WD_S3_BUCKET` | — | S3 bucket used by `wd sync s3` |

```bash
# ~/.zshrc
export WD_NOTES_DIR="$HOME/Dropbox/notes"
export WD_S3_BUCKET="my-bucket"
source ~/workstation-diary/sh/wd.sh
```

## 📦 Requirements

| Tool | Required? | Used for |
| --- | --- | --- |
| Bash or Zsh | ✅ | Running `wd` |
| `find`, `grep`, `sed` | ✅ | Listing and searching |
| `openssl` | ✅ | Unique filename generation |
| `nvim` / `vim` / `nano` | ✅ (any one) | Editing notes |
| [fzf](https://github.com/junegunn/fzf) | Optional | Interactive fuzzy selection |
| [bat](https://github.com/sharkdp/bat) | Optional | Syntax-highlighted previews |
| [rclone](https://rclone.org/) | Optional | `wd sync` |

## 💡 Tips

- **Daily log:** `alias today='wd add "daily-$(date +%F)" daily'`
- **Version your notes:** run `git init` inside `$WD_NOTES_DIR` for full history.
- **Shared folder:** point `WD_NOTES_DIR` at a Dropbox/iCloud folder for live multi-device access.

## 📄 License

[MIT](LICENSE) © ywsrock
