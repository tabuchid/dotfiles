#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ED_DIR="${REPO_DIR}/dotfiles/editors"

log() { printf "[editors] %s\n" "$*"; }

mkdir -p "${ED_DIR}/vscode" "${ED_DIR}/cursor"

copy_editor_user_subset() {
  local src_dir="$1"
  local dst_dir="$2"
  mkdir -p "$dst_dir"
  # Copy common user-level config files if they exist
  for f in settings.json keybindings.json locale.json argv.json; do
    if [[ -f "$src_dir/$f" ]]; then
      install -m 0644 "$src_dir/$f" "$dst_dir/$f"
    fi
  done
  # Copy snippets directory if present
  if [[ -d "$src_dir/snippets" ]]; then
    mkdir -p "$dst_dir/snippets"
    rsync -a --delete "$src_dir/snippets/" "$dst_dir/snippets/"
  fi
}

# VSCode settings subset
VSC_USER_DIR="$HOME/Library/Application Support/Code/User"
if [[ -d "$VSC_USER_DIR" ]]; then
  copy_editor_user_subset "$VSC_USER_DIR" "${ED_DIR}/vscode"
  log "Synced VSCode settings subset"
  VSC_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if [[ -x "$VSC_CLI" ]]; then
    "$VSC_CLI" --list-extensions > "${ED_DIR}/vscode/extensions.txt" || true
    log "Exported VSCode extensions"
  fi
else
  log "VSCode User dir not found"
fi

# Cursor settings subset
CUR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
if [[ -d "$CUR_USER_DIR" ]]; then
  copy_editor_user_subset "$CUR_USER_DIR" "${ED_DIR}/cursor"
  log "Synced Cursor settings subset"
  CUR_CLI="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  if [[ -x "$CUR_CLI" ]]; then
    "$CUR_CLI" --list-extensions > "${ED_DIR}/cursor/extensions.txt" || true
    log "Exported Cursor extensions"
  fi
else
  log "Cursor User dir not found"
fi
