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

copy_dir_if_exists() {
  local src="$1" dst="$2"
  if [[ -d "${src}" ]]; then
    mkdir -p "${dst}"
    if command -v rsync >/dev/null 2>&1; then
      rsync -a --delete "${src}/" "${dst}/"
    else
      # Fallback without delete sync
      cp -aR "${src}/." "${dst}/"
    fi
    log "Synced dir ${src} -> ${dst}"
  else
    log "Skip dir (missing): ${src}"
  fi
}

main() {
  copy_if_exists "${HOME}/.gitconfig" "${DOTS_DIR}/.gitconfig"
  copy_if_exists "${HOME}/.p10k.zsh" "${DOTS_DIR}/.p10k.zsh"
  copy_if_exists "${HOME}/.tmux.conf.local" "${DOTS_DIR}/.tmux.conf.local"
  copy_if_exists "${HOME}/.zprofile" "${DOTS_DIR}/.zprofile"
  copy_dir_if_exists "${HOME}/.doom.d" "${DOTS_DIR}/doom.d"

  # Shell customizations
  copy_if_exists "${HOME}/.zsh_aliases" "${DOTS_DIR}/.zsh_aliases"
  copy_dir_if_exists "${HOME}/.zshrc.d" "${DOTS_DIR}/zshrc.d"
  copy_dir_if_exists "${HOME}/.zshrc.pre-plugins.d" "${DOTS_DIR}/zshrc.pre-plugins.d"

  # XDG config selections
  copy_dir_if_exists "${HOME}/.config/mise" "${DOTS_DIR}/config/mise"
  copy_dir_if_exists "${HOME}/.config/wezterm" "${DOTS_DIR}/config/wezterm"
  copy_dir_if_exists "${HOME}/.config/ghostty" "${DOTS_DIR}/config/ghostty"
  copy_dir_if_exists "${HOME}/.config/htop" "${DOTS_DIR}/config/htop"
  copy_dir_if_exists "${HOME}/.config/git" "${DOTS_DIR}/config/git"
  copy_dir_if_exists "${HOME}/.config/raycast" "${DOTS_DIR}/config/raycast"

  # GitHub CLI (safe subset)
  if [[ -f "${HOME}/.config/gh/config.yml" ]]; then
    mkdir -p "${DOTS_DIR}/config/gh"
    install -m 0644 "${HOME}/.config/gh/config.yml" "${DOTS_DIR}/config/gh/config.yml"
  fi
  if command -v gh >/dev/null 2>&1; then
    gh extension list | awk '{print $1}' > "${DOTS_DIR}/config/gh/extensions.txt" || true
  fi

  log "Sync complete."
}

main "$@"
