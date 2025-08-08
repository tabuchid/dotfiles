#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTS_DIR="${REPO_DIR}/dotfiles"

log() { printf "[sync] %s\n" "$*"; }

copy_if_exists() {
  local src="$1" dst="$2"
  if [[ -f "${src}" ]]; then
    mkdir -p "$(dirname "${dst}")"
    cp -v "${src}" "${dst}"
  else
    log "Skip (missing): ${src}"
  fi
}

main() {
  copy_if_exists "${HOME}/.gitconfig" "${DOTS_DIR}/.gitconfig"
  copy_if_exists "${HOME}/.p10k.zsh" "${DOTS_DIR}/.p10k.zsh"
  copy_if_exists "${HOME}/.tmux.conf.local" "${DOTS_DIR}/.tmux.conf.local"
  copy_if_exists "${HOME}/.zprofile" "${DOTS_DIR}/.zprofile"
  log "Sync complete."
}

main "$@"
