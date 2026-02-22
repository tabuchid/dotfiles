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

install_sf_mono() {
  "${REPO_DIR}/scripts/install-sf-mono.sh" || true
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

link_emacs_plus_build_config() {
  local src="${REPO_DIR}/dotfiles/config/emacs-plus"
  local dst="${HOME}/.config/emacs-plus"

  if [[ ! -e "${src}" ]]; then
    log "No emacs-plus build config found at ${src}; skipping pre-brew link"
    return 0
  fi

  if [[ -L "${dst}" && "$(readlink "${dst}")" == "${src}" ]]; then
    log "emacs-plus build config already linked"
    return 0
  fi

  if [[ -e "${dst}" ]]; then
    local bak="${dst}.bak.$(date +%s)"
    log "Backing up ${dst} -> ${bak}"
    mv -v "${dst}" "${bak}"
  fi
  mkdir -p "$(dirname "${dst}")"
  ln -sv "${src}" "${dst}"
}

setup_emacs_app() {
  local prefix
  prefix="$(brew --prefix emacs-plus@30 2>/dev/null)" || return 0

  if ! command -v osascript >/dev/null 2>&1; then
    return 0
  fi

  if [[ -d "$prefix/Emacs.app" && ! -e "/Applications/Emacs.app" ]]; then
    log "Creating Emacs.app alias in /Applications"
    osascript -e "tell application \"Finder\" to make alias file to posix file \"$prefix/Emacs.app\" at posix file \"/Applications\" with properties {name:\"Emacs.app\"}" || log "Skipping Emacs.app alias (Finder automation unavailable)"
  fi
  if [[ -d "$prefix/Emacs Client.app" && ! -e "/Applications/Emacs Client.app" ]]; then
    log "Creating Emacs Client.app alias in /Applications"
    osascript -e "tell application \"Finder\" to make alias file to posix file \"$prefix/Emacs Client.app\" at posix file \"/Applications\" with properties {name:\"Emacs Client.app\"}" || log "Skipping Emacs Client.app alias (Finder automation unavailable)"
  fi
}

main() {
  ensure_clt
  ensure_brew
  link_emacs_plus_build_config
  restore_brew
  install_sf_mono
  setup_emacs_app
  install_zsh_framework
  install_tmux_framework
  sync_editors
  link_dotfiles
  install_doom
  log "Done. Open a new terminal session to pick up changes."
}

main "$@"
