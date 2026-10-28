# WD (Workstation Diary)

[English](README.md) | [日本語](README_ja.md)

A small shell function for writing and finding notes from the terminal.

Notes are plain Markdown files in a single directory, so you can still read them with any editor, grep them, or put them under Git. WD just takes care of the tedious parts: naming files, adding a header, and getting you back to the note you want quickly.

```console
$ wd add "Fix login bug" work urgent
$ wd recent
$ wd grep timeout -f
$ wd sync gdrive
```

## Installation

```bash
git clone git@github.com:ywsrock/workstation-diary.git ~/workstation-diary
echo 'source ~/workstation-diary/sh/wd.sh' >> ~/.zshrc   # or ~/.bashrc
source ~/.zshrc
```

Notes go into `~/notes` by default. The directory is created on first use.

fzf, bat and rclone are optional, but WD is much nicer to use with fzf and bat installed:

```bash
brew install fzf bat rclone
```

Without fzf you get a numbered menu instead, and without bat previews fall back to plain text.

## Notes

`wd add "Fix login bug" work urgent` creates a file like this:

```
~/notes/20261028_142305_a1b2c3d4_Fix login bug.md
```

The name is the date, the time, a short random string, and the title. Because it starts with the date, an ordinary `ls` already lists notes in the order they were written.

The file starts with a small header, and then opens in your editor (nvim, vim, or nano, whichever is found first):

```markdown
---
title: Fix login bug
date: 20261028
tags: work urgent
---
```

## Commands

| Command | Description |
| --- | --- |
| `wd add <name> [tags...]` | Create a note and open it |
| `wd open [name]` | Open a note |
| `wd list [keyword]` | List notes, optionally only those containing a keyword, and open one |
| `wd recent [count]` | Choose from recently modified notes (default 5) |
| `wd preview [name]` | Show the first 50 lines of a note |
| `wd search <regex>` | Search all notes with a regular expression |
| `wd grep <keyword> [-f]` | Case-insensitive search; `-f` to choose a result with fzf |
| `wd tag [name]` | Show and change a note's tags |
| `wd tag search <tag>` | List notes with a tag |
| `wd delete [name]` | Delete a note (asks first) |
| `wd sync <gdrive\|s3>` | Back up notes with rclone |
| `wd config` | Show the notes directory |
| `wd help [command]` | Show help |

For commands that take `[name]`, part of the title is enough (`wd open login`), and case doesn't matter. If more than one note matches, you'll be asked to pick one. If you leave the name out, you'll get a list of all notes to choose from.

Some examples:

```bash
wd open                    # choose from all notes
wd list project            # notes that mention "project"
wd recent 10               # last 10 notes
wd search "TODO.*urgent"   # regex, case-sensitive
wd grep important -f       # pick a match in fzf, preview opens at that line
wd tag search work         # every note tagged "work"
```

## Backup

`wd sync` uploads your notes with `rclone copy --update`. Only new or changed files are sent, and nothing on the remote side is ever deleted. It is a one-way backup; it does not pull changes back down.

Set up an rclone remote first with `rclone config`. WD expects the remote to have a specific name:

| Command | rclone remote | Uploaded to |
| --- | --- | --- |
| `wd sync gdrive` | `gdrive` | `gdrive:WDNotes` |
| `wd sync s3` | `s3` | `s3:$WD_S3_BUCKET/notes` |

For S3, set the bucket name first:

```bash
export WD_S3_BUCKET="my-bucket"
wd sync s3
```

## Configuration

| Variable | Default | |
| --- | --- | --- |
| `WD_NOTES_DIR` | `$HOME/notes` | Where notes are stored |
| `WD_S3_BUCKET` | (none) | Bucket used by `wd sync s3` |

Set these before the `source` line in your shell config:

```bash
export WD_NOTES_DIR="$HOME/Dropbox/notes"
source ~/workstation-diary/sh/wd.sh
```

## Requirements

- Bash or Zsh
- `find`, `grep`, `sed`, `openssl` (all present on macOS and most Linux systems)
- nvim, vim, or nano
- Optional: [fzf](https://github.com/junegunn/fzf), [bat](https://github.com/sharkdp/bat), [rclone](https://rclone.org/)

## Tips

A daily log is one alias away:

```bash
alias today='wd add "daily-$(date +%F)" daily'
```

If you want history for your notes, run `git init` in the notes directory. If you want them on several machines at once, point `WD_NOTES_DIR` at a Dropbox or iCloud folder.

## License

MIT. See [LICENSE](LICENSE).
