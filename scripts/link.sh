#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTS_DIR="${REPO_DIR}/dotfiles"

log() { printf "[link] %s\n" "$*"; }

backup_and_link() {
  local src="$1" dst="$2"
  if [[ -L "${dst}" && "$(readlink "${dst}")" == "${src}" ]]; then
    log "OK  ${dst} -> ${src}"
    return 0
  fi
  if [[ -e "${dst}" ]]; then
    local bak="${dst}.bak.$(date +%s)"
    log "Backup ${dst} -> ${bak}"
    mv -v "${dst}" "${bak}"
  fi
  mkdir -p "$(dirname "${dst}")"
  ln -sv "${src}" "${dst}"
}

main() {
  declare -A MAP=(
    ["${DOTS_DIR}/.gitconfig"]="${HOME}/.gitconfig"
    ["${DOTS_DIR}/.p10k.zsh"]="${HOME}/.p10k.zsh"
    ["${DOTS_DIR}/.tmux.conf.local"]="${HOME}/.tmux.conf.local"
    ["${DOTS_DIR}/.zprofile"]="${HOME}/.zprofile"
    ["${DOTS_DIR}/doom.d"]="${HOME}/.doom.d"
  )
  for src in "${!MAP[@]}"; do
    dst="${MAP[$src]}"
    if [[ -e "${src}" ]]; then
      backup_and_link "${src}" "${dst}"
    else
      log "Skip (missing): ${src}"
    fi
  done
}

main "$@"
