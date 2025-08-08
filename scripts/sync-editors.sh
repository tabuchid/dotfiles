#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ED_DIR="${REPO_DIR}/dotfiles/editors"

log() { printf "[editors] %s\n" "$*"; }

mkdir -p "${ED_DIR}/vscode" "${ED_DIR}/cursor"

# VSCode settings
VSC_USER_DIR="$HOME/Library/Application Support/Code/User"
if [[ -d "$VSC_USER_DIR" ]]; then
  rsync -a --delete "$VSC_USER_DIR/" "${ED_DIR}/vscode/"
  log "Synced VSCode User settings to ${ED_DIR}/vscode"
  # Export extensions
  VSC_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if [[ -x "$VSC_CLI" ]]; then
    "$VSC_CLI" --list-extensions > "${ED_DIR}/vscode/extensions.txt" || true
    log "Exported VSCode extensions"
  fi
else
  log "VSCode User dir not found"
fi

# Cursor settings
CUR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
if [[ -d "$CUR_USER_DIR" ]]; then
  rsync -a --delete "$CUR_USER_DIR/" "${ED_DIR}/cursor/"
  log "Synced Cursor User settings to ${ED_DIR}/cursor"
  CUR_CLI="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  if [[ -x "$CUR_CLI" ]]; then
    "$CUR_CLI" --list-extensions > "${ED_DIR}/cursor/extensions.txt" || true
    log "Exported Cursor extensions"
  fi
else
  log "Cursor User dir not found"
fi
