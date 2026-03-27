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

link_gh_safe_files() {
  local gh_src_dir="${DOTS_DIR}/config/gh"
  local gh_dst_dir="${HOME}/.config/gh"
  local gh_cfg_src="${gh_src_dir}/config.yml"
  local gh_cfg_dst="${gh_dst_dir}/config.yml"

  if [[ -e "${gh_cfg_src}" ]]; then
    backup_and_link "${gh_cfg_src}" "${gh_cfg_dst}"
  else
    log "Skip (missing): ${gh_cfg_src}"
  fi
}

main() {
  declare -A MAP=(
    ["${DOTS_DIR}/.gitconfig"]="${HOME}/.gitconfig"
    ["${DOTS_DIR}/.p10k.zsh"]="${HOME}/.p10k.zsh"
    ["${DOTS_DIR}/.tmux.conf.local"]="${HOME}/.tmux.conf.local"
    ["${DOTS_DIR}/.zprofile"]="${HOME}/.zprofile"
    ["${DOTS_DIR}/doom.d"]="${HOME}/.config/doom"
    ["${DOTS_DIR}/editors/vscode"]="${HOME}/Library/Application Support/Code/User"
    ["${DOTS_DIR}/editors/cursor"]="${HOME}/Library/Application Support/Cursor/User"
    ["${DOTS_DIR}/.zsh_aliases"]="${HOME}/.zsh_aliases"
    ["${DOTS_DIR}/zshrc.d"]="${HOME}/.zshrc.d"
    ["${DOTS_DIR}/zshrc.pre-plugins.d"]="${HOME}/.zshrc.pre-plugins.d"
    ["${DOTS_DIR}/config/emacs-plus"]="${HOME}/.config/emacs-plus"
    ["${DOTS_DIR}/config/mise"]="${HOME}/.config/mise"
    ["${DOTS_DIR}/config/wezterm"]="${HOME}/.config/wezterm"
    ["${DOTS_DIR}/config/htop"]="${HOME}/.config/htop"
    ["${DOTS_DIR}/config/git"]="${HOME}/.config/git"
    ["${DOTS_DIR}/config/eza"]="${HOME}/.config/eza"
  )
  for src in "${!MAP[@]}"; do
    dst="${MAP[$src]}"
    if [[ -e "${src}" ]]; then
      backup_and_link "${src}" "${dst}"
    else
      log "Skip (missing): ${src}"
    fi
  done
  link_gh_safe_files
}

main "$@"
