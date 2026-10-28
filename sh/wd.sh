#!/bin/bash

wd() {
    # Use environment variable if set, otherwise use default
    local notes_dir="${WD_NOTES_DIR:-$HOME/notes}"
    local date=$(date +%Y%m%d)
    local timestamp=$(date +%H%M%S)
    local editor=$(command -v nvim || command -v vim || echo "nano")

    # fzf preview commands (fall back to head/tail when bat is not installed)
    local file_preview="head -n 50 {}"
    local line_preview="tail -n +{2} {1} | head -n 50"
    if command -v bat &> /dev/null; then
        file_preview="bat --style=numbers --color=always --line-range :50 {}"
        line_preview="bat --style=numbers --color=always --line-range {2}: {1}"
    fi

    # Create notes directory if it doesn't exist
    mkdir -p "$notes_dir"

    # Function to generate a unique filename
    generate_unique_filename() {
        local base_name="$1"
        local random_string=$(openssl rand -hex 4)
        echo "${date}_${timestamp}_${random_string}_${base_name}.md"
    }

    # Function to confirm deletion
    confirm_deletion() {
        local file="$1"
        echo "Are you sure you want to delete this file? (y/n)"
        echo "File: $file"
        read -r confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            rm "$file"
            echo "Deleted: $file"
        else
            echo "Deletion cancelled."
        fi
    }

    # Function to print notes (one path per line on stdin) with their first line
    print_notes() {
        local file
        while IFS= read -r file; do
            [ -n "$file" ] || continue
            echo -e "\033[1m$file:\033[0m"
            head -n 1 "$file"
            echo
        done
    }

    # Function to select a file using fzf or select
    # Files are passed as a single newline-separated string so paths may contain spaces
    select_file() {
        local prompt="$1"
        local list="$2"
        if [ -z "$list" ]; then
            echo "No files found." >&2
            return 1
        fi
        if command -v fzf &> /dev/null; then
            printf '%s\n' "$list" | fzf --prompt="$prompt" --preview "$file_preview"
        else
            local files=() line file
            while IFS= read -r line; do
                files+=("$line")
            done <<< "$list"
            echo "$prompt" >&2
            select file in "${files[@]}"; do
                if [ -n "$file" ]; then
                    echo "$file"
                    return 0
                else
                    echo "Invalid selection. Please try again." >&2
                fi
            done
        fi
    }

    # Function to find a file by name (case-insensitive partial match on the file name)
    # Prompts for a choice when several notes match
    find_file() {
        local name="$1"
        local matches=$(find "$notes_dir" -name "*.md" -type f -iname "*$name*")
        if [ $(printf '%s\n' "$matches" | grep -c .) -gt 1 ]; then
            select_file "Multiple notes match '$name':" "$matches"
        else
            echo "$matches"
        fi
    }

    # Function to list notes and optionally select one
    list_notes() {
        local filter="$1"
        local select_mode="$2"
        local files

        if [ -z "$filter" ]; then
            files=$(find "$notes_dir" -name "*.md" -type f)
        else
            files=$(find "$notes_dir" -name "*.md" -type f -exec grep -il -- "$filter" {} +)
        fi

        if [ "$select_mode" = "select" ]; then
            select_file "Select a file to open:" "$files"
        else
            printf '%s\n' "$files" | print_notes
        fi
    }

    # Function to list recent notes and optionally select one
    list_recent_notes() {
        local count=${1:-5}
        local select_mode="$2"
        local files=$(find "$notes_dir" -name "*.md" -type f -exec ls -t {} + | head -n "$count")

        if [ "$select_mode" = "select" ]; then
            select_file "Select a file to open:" "$files"
        else
            printf '%s\n' "$files" | print_notes
        fi
    }

    # Function to search by tag
    search_by_tag() {
        local tag="$1"
        find "$notes_dir" -name "*.md" -type f -exec grep -l -- "^tags:.*$tag" {} + | print_notes
    }

    # Function to sync notes with a remote using rclone
    sync_with_rclone() {
        local remote="$1"
        local remote_path="$2"

        if ! command -v rclone &> /dev/null; then
            echo "rclone is not installed. Please install it to use cloud sync."
            return 1
        fi

        rclone copy --update --verbose "$notes_dir" "$remote:$remote_path"
        echo "Synced notes to $remote (only updated or new files, no deletions)."
    }

    case "$1" in
        add)
            if [ -z "$2" ]; then
                echo "Usage: wd add <note_name> [tags]"
                return 1
            fi
            local file_name=$(generate_unique_filename "$2")
            local tags="${@:3}"
            echo "---" > "$notes_dir/$file_name"
            echo "title: $2" >> "$notes_dir/$file_name"
            echo "date: $date" >> "$notes_dir/$file_name"
            echo "tags: $tags" >> "$notes_dir/$file_name"
            echo "---" >> "$notes_dir/$file_name"
            echo "" >> "$notes_dir/$file_name"
            $editor "$notes_dir/$file_name"
            ;;
        list)
            local filter="$2"
            local selected_file=$(list_notes "$filter" "select")
            if [ -n "$selected_file" ]; then
                $editor "$selected_file"
            else
                echo "No file selected."
            fi
            ;;
        delete)
            if [ -z "$2" ]; then
                local file_to_delete=$(select_file "Select a file to delete:" "$(find "$notes_dir" -name "*.md" -type f)")
            else
                local file_to_delete=$(find_file "$2")
            fi
            if [ -n "$file_to_delete" ]; then
                confirm_deletion "$file_to_delete"
            else
                echo "No file found to delete."
            fi
            ;;
        open)
            if [ -z "$2" ]; then
                local file_to_open=$(select_file "Select a file to open:" "$(find "$notes_dir" -name "*.md" -type f)")
            else
                local file_to_open=$(find_file "$2")
            fi
            if [ -n "$file_to_open" ]; then
                $editor "$file_to_open"
            else
                echo "No file found to open."
            fi
            ;;
        search)
            if [ -z "$2" ]; then
                echo "Usage: wd search <regex_pattern>"
                return 1
            fi
            if command -v fzf &> /dev/null; then
                grep -r -n "$2" "$notes_dir" | fzf --delimiter : --preview "$line_preview"
            else
                grep -r -n "$2" "$notes_dir"
            fi
            ;;
        grep)
            if [ -z "$2" ]; then
                echo "Usage: wd grep <keyword> [-f]"
                return 1
            fi
            local keyword="$2"
            local use_fzf=false
            if [ "$3" = "-f" ] && command -v fzf &> /dev/null; then
                use_fzf=true
            fi
            
            if $use_fzf; then
                grep -r -n -i "$keyword" "$notes_dir" | fzf --delimiter : --preview "$line_preview"
            else
                grep -r -n -i --color=always "$keyword" "$notes_dir"
            fi
            ;;
        preview)
            if [ -z "$2" ]; then
                local file_to_preview=$(select_file "Select a file to preview:" "$(find "$notes_dir" -name "*.md" -type f)")
            else
                local file_to_preview=$(find_file "$2")
            fi
            if [ -n "$file_to_preview" ]; then
                if command -v bat &> /dev/null; then
                    bat --style=numbers --color=always --line-range :50 "$file_to_preview"
                else
                    head -n 50 "$file_to_preview"
                fi
            else
                echo "No file found to preview."
            fi
            ;;
        tag)
            if [ "$2" = "search" ]; then
                if [ -z "$3" ]; then
                    echo "Usage: wd tag search <tag_name>"
                    return 1
                fi
                search_by_tag "$3"
                return 0
            elif [ -z "$2" ]; then
                local file_to_tag=$(select_file "Select a file to view/edit tags:" "$(find "$notes_dir" -name "*.md" -type f)")
            else
                local file_to_tag=$(find_file "$2")
            fi
            if [ -n "$file_to_tag" ]; then
                local current_tags=$(grep "^tags:" "$file_to_tag" | sed 's/^tags: *//')
                echo "Current tags: $current_tags"
                echo "Enter new tags (or press Enter to keep current tags):"
                read -r new_tags
                if [ -n "$new_tags" ]; then
                    # -i.bak works with both GNU sed and BSD sed (macOS)
                    sed -i.bak "s/^tags:.*$/tags: $new_tags/" "$file_to_tag" && rm -f "$file_to_tag.bak"
                    echo "Tags updated for $file_to_tag"
                else
                    echo "Tags unchanged."
                fi
            else
                echo "No file found for tagging."
            fi
            ;;
        recent)
            local count=${2:-5}
            local selected_file=$(list_recent_notes "$count" "select")
            if [ -n "$selected_file" ]; then
                $editor "$selected_file"
            else
                echo "No file selected."
            fi
            ;;
        sync)
            case "$2" in
                gdrive)
                    sync_with_rclone "gdrive" "WDNotes"
                    ;;
                s3)
                    if [ -z "$WD_S3_BUCKET" ]; then
                        echo "Please set the WD_S3_BUCKET environment variable."
                        return 1
                    fi
                    sync_with_rclone "s3" "$WD_S3_BUCKET/notes"
                    ;;
                *)
                    echo "Usage: wd sync [gdrive|s3]"
                    echo "Make sure you have configured rclone for the chosen remote."
                    echo "This will only update or add files, not delete any in the destination."
                    ;;
            esac
            ;;
        config)
            echo "Current notes directory: $notes_dir"
            echo "To change the directory, set the WD_NOTES_DIR environment variable."
            echo "For example: export WD_NOTES_DIR=/path/to/your/notes"
            ;;
        help)
            if [ -n "$2" ]; then
                case "$2" in
                    add)     echo "Usage: wd add <note_name> [tags]"
                             echo "Create a new note with front matter (title, date, tags) and open it in the editor." ;;
                    list)    echo "Usage: wd list [keyword]"
                             echo "List all notes, or only notes containing keyword, then select one to open." ;;
                    delete)  echo "Usage: wd delete [note_name]"
                             echo "Delete a note after confirmation. Select interactively if no name is given." ;;
                    open)    echo "Usage: wd open [note_name]"
                             echo "Open a note in the editor. Select interactively if no name is given." ;;
                    search)  echo "Usage: wd search <regex_pattern>"
                             echo "Search all notes with a regex (uses fzf if installed)." ;;
                    grep)    echo "Usage: wd grep <keyword> [-f]"
                             echo "Case-insensitive search in all notes. Use -f to select results with fzf." ;;
                    preview) echo "Usage: wd preview [note_name]"
                             echo "Show the first 50 lines of a note. Select interactively if no name is given." ;;
                    tag)     echo "Usage: wd tag [note_name]"
                             echo "       wd tag search <tag_name>"
                             echo "View or edit a note's tags, or search notes by tag." ;;
                    recent)  echo "Usage: wd recent [count]"
                             echo "Select from the most recently modified notes (default: 5)." ;;
                    sync)    echo "Usage: wd sync [gdrive|s3]"
                             echo "Upload new or updated notes with rclone (no deletions on the remote)."
                             echo "gdrive -> gdrive:WDNotes, s3 -> s3:\$WD_S3_BUCKET/notes" ;;
                    config)  echo "Usage: wd config"
                             echo "Show the current notes directory." ;;
                    *)       echo "Unknown command: $2. Use 'wd help' for a list of commands."
                             return 1 ;;
                esac
                return 0
            fi
            echo "Usage: wd <command> [args]"
            echo "Commands:"
            echo "  add <note_name> [tags] - Add a new note"
            echo "  list [keyword]         - List all notes or search by keyword, then select to open"
            echo "  delete [note_name]     - Delete a note (interactive selection if no name provided)"
            echo "  open [note_name]       - Open a note (interactive selection if no name provided)"
            echo "  search <regex_pattern> - Search within notes using regex"
            echo "  grep <keyword> [-f]    - Grep for keyword in all notes (use -f for fzf)"
            echo "  preview [note_name]    - Preview a note (interactive selection if no name provided)"
            echo "  tag [note_name]        - View or edit tags of a note (interactive selection if no name provided)"
            echo "  tag search <tag_name>  - Search notes by tag"
            echo "  recent [count]         - Show and select from recent notes (default: 5)"
            echo "  sync [gdrive|s3]       - Safely sync notes with Google Drive or AWS S3 using rclone (no deletions)"
            echo "  config                 - Show current configuration"
            echo "  help                   - Show this help message"
            echo
            echo "Configuration:"
            echo "  Set WD_NOTES_DIR environment variable to change the notes directory."
            echo "  Current notes directory: $notes_dir"
            echo
            echo "For more detailed help on a specific command, use: wd help <command>"
            ;;
        *)
            echo "Unknown command. Use 'wd help' for usage information."
            ;;
    esac
}
