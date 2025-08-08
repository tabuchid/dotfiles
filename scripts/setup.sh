#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="${REPO_DIR}/Brewfile"

log() { printf "\n[setup] %s\n" "$*"; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }

ensure_clt() {
  if ! xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools not found. Please run: xcode-select --install"
    exit 1
  fi
}

ensure_brew() {
  if ! need_cmd brew; then
    log "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # shellcheck disable=SC1090
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # shellcheck disable=SC1090
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

restore_brew() {
  if [[ -f "${BREWFILE}" ]]; then
    log "Restoring Homebrew packages from Brewfile"
    brew bundle --file "${BREWFILE}" --no-upgrade || true
  else
    log "No Brewfile found at ${BREWFILE}; skipping"
  fi
}

install_zsh_framework() {
  "${REPO_DIR}/scripts/install-zsh-quickstart.sh"
}

install_tmux_framework() {
  "${REPO_DIR}/scripts/install-oh-my-tmux.sh"
}

install_doom() {
  "${REPO_DIR}/scripts/install-doom.sh"
}

sync_editors() {
  "${REPO_DIR}/scripts/sync-editors.sh" || true
}

link_dotfiles() {
  "${REPO_DIR}/scripts/link.sh"
}

main() {
  ensure_clt
  ensure_brew
  restore_brew
  install_zsh_framework
  install_tmux_framework
  sync_editors
  link_dotfiles
  install_doom
  log "Done. Open a new terminal session to pick up changes."
}

main "$@"
