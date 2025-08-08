#!/usr/bin/env bash
set -euo pipefail

log() { printf "[tmux] %s\n" "$*"; }

TMUX_DIR="$HOME/.tmux"
TMUX_REPO="https://github.com/gpakosz/.tmux.git"
TMUX_CONF_LINK="$HOME/.tmux.conf"
TMUX_CONF_TARGET="$HOME/.tmux/.tmux.conf"

if [[ ! -d "${TMUX_DIR}/.git" ]]; then
  if [[ -d "${TMUX_DIR}" ]]; then
    log "Directory ${TMUX_DIR} exists but is not a git repo; backing up"
    mv -v "${TMUX_DIR}" "${TMUX_DIR}.bak.$(date +%s)"
  fi
  log "Cloning ${TMUX_REPO} into ${TMUX_DIR}"
  git clone --depth 1 "${TMUX_REPO}" "${TMUX_DIR}"
else
  log "Oh My Tmux already present; pulling updates"
  git -C "${TMUX_DIR}" pull --ff-only || true
fi

# Link ~/.tmux.conf
if [[ -L "${TMUX_CONF_LINK}" && "$(readlink "${TMUX_CONF_LINK}")" == "${TMUX_CONF_TARGET}" ]]; then
  log "~/.tmux.conf already linked"
else
  if [[ -e "${TMUX_CONF_LINK}" ]]; then
    log "Backing up existing ~/.tmux.conf"
    mv -v "${TMUX_CONF_LINK}" "${TMUX_CONF_LINK}.bak.$(date +%s)"
  fi
  ln -sv "${TMUX_CONF_TARGET}" "${TMUX_CONF_LINK}"
fi
