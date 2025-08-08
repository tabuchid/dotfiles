#!/usr/bin/env bash
set -euo pipefail

log() { printf "[zsh] %s\n" "$*"; }

ZQS_DIR="$HOME/zsh-quickstart-kit"
ZQS_REPO="https://github.com/unixorn/zsh-quickstart-kit.git"
TARGET_ZSHRC_LINK="$HOME/.zshrc"
ZQS_ZSHRC_REL="zsh-quickstart-kit/zsh/.zshrc"

if [[ ! -d "${ZQS_DIR}/.git" ]]; then
  if [[ -d "${ZQS_DIR}" ]]; then
    log "Directory ${ZQS_DIR} exists but is not a git repo; backing up"
    mv -v "${ZQS_DIR}" "${ZQS_DIR}.bak.$(date +%s)"
  fi
  log "Cloning ${ZQS_REPO} into ${ZQS_DIR}"
  git clone --depth 1 "${ZQS_REPO}" "${ZQS_DIR}"
else
  log "zsh-quickstart-kit already present; pulling updates"
  git -C "${ZQS_DIR}" pull --ff-only || true
fi

# Link ~/.zshrc to the framework's managed file
if [[ -L "${TARGET_ZSHRC_LINK}" && "$(readlink "${TARGET_ZSHRC_LINK}")" == "${ZQS_ZSHRC_REL}" ]]; then
  log "~/.zshrc already linked to ${ZQS_ZSHRC_REL}"
else
  if [[ -e "${TARGET_ZSHRC_LINK}" ]]; then
    log "Backing up existing ~/.zshrc"
    mv -v "${TARGET_ZSHRC_LINK}" "${TARGET_ZSHRC_LINK}.bak.$(date +%s)"
  fi
  ln -sv "${ZQS_ZSHRC_REL}" "${TARGET_ZSHRC_LINK}"
fi
