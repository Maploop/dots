#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$SCRIPT_DIR/old.bak"

# Move the entire previous config aside, including hidden files and symlinks.
# Keep earlier backups by adding .1, .2, etc. when a name is already taken.
backup_config() {
    local name="$1"
    local destination="$CONFIG_DIR/$name"
    local backup_path="$BACKUP_DIR/$name"
    local suffix=1

    if [[ ! -e "$destination" && ! -L "$destination" ]]; then
        return
    fi

    mkdir -p -- "$BACKUP_DIR"
    while [[ -e "$backup_path" || -L "$backup_path" ]]; do
        backup_path="$BACKUP_DIR/$name.$suffix"
        suffix=$((suffix + 1))
    done

    mv -- "$destination" "$backup_path"
    printf 'Backed up %s to %s\n' "$name" "$backup_path"
}

# Include hidden files when moving config contents, but never . or .. .
shopt -s dotglob nullglob

move_directory_contents() {
    local source_dir="$1"
    local destination_dir="$2"
    local item name

    mkdir -p -- "$destination_dir"

    for item in "$source_dir"/*; do
        name="${item##*/}"

        if [[ -d "$item" && ! -L "$item" ]]; then
            move_directory_contents "$item" "$destination_dir/$name"
            rmdir -- "$item"
        else
            mv -f -- "$item" "$destination_dir/$name"
        fi
    done
}

install_directory() {
    local name="$1"
    local source_dir="$SCRIPT_DIR/$name"
    local destination_dir="$CONFIG_DIR/$name"

    if [[ ! -d "$source_dir" ]]; then
        printf 'Error: missing config directory: %s\n' "$source_dir" >&2
        exit 1
    fi

    if [[ "$source_dir" == "$destination_dir" || "$source_dir" -ef "$destination_dir" ]]; then
        printf '%s is already in %s\n' "$name" "$destination_dir"
        return
    fi

    printf 'Installing %s...\n' "$name"
    backup_config "$name"
    move_directory_contents "$source_dir" "$destination_dir"
    rmdir -- "$source_dir"
}

install_file() {
    local name="$1"
    local source_file="$SCRIPT_DIR/$name"

    if [[ ! -f "$source_file" ]]; then
        printf 'Error: missing config file: %s\n' "$source_file" >&2
        exit 1
    fi

    if [[ "$source_file" == "$CONFIG_DIR/$name" || "$source_file" -ef "$CONFIG_DIR/$name" ]]; then
        printf '%s is already in %s\n' "$name" "$CONFIG_DIR"
        return
    fi

    printf 'Installing %s...\n' "$name"
    mkdir -p -- "$CONFIG_DIR"
    backup_config "$name"
    mv -f -- "$source_file" "$CONFIG_DIR/$name"
}

install_directory fastfetch
install_directory hypr
install_directory kitty
install_directory mako
install_directory rofi
install_directory swaylock
install_directory waybar
install_file starship.toml

printf 'Configuration installed in %s\n' "$CONFIG_DIR"
