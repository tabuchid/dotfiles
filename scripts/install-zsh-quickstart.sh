#!/usr/bin/env bash
set -euo pipefail

log() { printf "[zsh] %s\n" "$*"; }
warn() { printf "[zsh] WARNING: %s\n" "$*"; }

ZGENOM_DIR="$HOME/.zgenom"
ZGENOM_REPO="https://github.com/jandamm/zgenom.git"
ZQS_DIR="$HOME/zsh-quickstart-kit"
ZQS_REPO="https://github.com/unixorn/zsh-quickstart-kit.git"
TARGET_ZSHRC_LINK="$HOME/.zshrc"
ZQS_ZSHRC_REL="zsh-quickstart-kit/zsh/.zshrc"
TARGET_ZGEN_SETUP_LINK="$HOME/.zgen-setup"
ZQS_ZGEN_SETUP_REL="zsh-quickstart-kit/zsh/.zgen-setup"
TARGET_ZSH_FUNCTIONS_LINK="$HOME/.zsh_functions"
ZQS_ZSH_FUNCTIONS_REL="zsh-quickstart-kit/zsh/.zsh_functions"
ZGENOM_INIT_FILE="$HOME/.zgenom/init.zsh"

if [[ ! -d "${ZGENOM_DIR}/.git" ]]; then
  if [[ -d "${ZGENOM_DIR}" ]]; then
    log "Directory ${ZGENOM_DIR} exists but is not a git repo; backing up"
    mv -v "${ZGENOM_DIR}" "${ZGENOM_DIR}.bak.$(date +%s)"
  fi
  log "Cloning ${ZGENOM_REPO} into ${ZGENOM_DIR}"
  git clone "${ZGENOM_REPO}" "${ZGENOM_DIR}"
else
  log "zgenom already present; pulling updates"
  git -C "${ZGENOM_DIR}" pull --ff-only || true
fi

if [[ ! -d "${ZQS_DIR}/.git" ]]; then
  if [[ -d "${ZQS_DIR}" ]]; then
    log "Directory ${ZQS_DIR} exists but is not a git repo; backing up"
    mv -v "${ZQS_DIR}" "${ZQS_DIR}.bak.$(date +%s)"
  fi
  log "Cloning ${ZQS_REPO} into ${ZQS_DIR}"
  git clone "${ZQS_REPO}" "${ZQS_DIR}"
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

# Link quickstart helper files required by upstream ~/.zshrc.
# ~/.zsh_aliases is repo-owned and linked by scripts/link.sh.
if [[ -L "${TARGET_ZGEN_SETUP_LINK}" && "$(readlink "${TARGET_ZGEN_SETUP_LINK}")" == "${ZQS_ZGEN_SETUP_REL}" ]]; then
  log "~/.zgen-setup already linked to ${ZQS_ZGEN_SETUP_REL}"
else
  if [[ -e "${TARGET_ZGEN_SETUP_LINK}" ]]; then
    log "Backing up existing ~/.zgen-setup"
    mv -v "${TARGET_ZGEN_SETUP_LINK}" "${TARGET_ZGEN_SETUP_LINK}.bak.$(date +%s)"
  fi
  ln -sv "${ZQS_ZGEN_SETUP_REL}" "${TARGET_ZGEN_SETUP_LINK}"
fi

if [[ -L "${TARGET_ZSH_FUNCTIONS_LINK}" && "$(readlink "${TARGET_ZSH_FUNCTIONS_LINK}")" == "${ZQS_ZSH_FUNCTIONS_REL}" ]]; then
  log "~/.zsh_functions already linked to ${ZQS_ZSH_FUNCTIONS_REL}"
else
  if [[ -e "${TARGET_ZSH_FUNCTIONS_LINK}" ]]; then
    log "Backing up existing ~/.zsh_functions"
    mv -v "${TARGET_ZSH_FUNCTIONS_LINK}" "${TARGET_ZSH_FUNCTIONS_LINK}.bak.$(date +%s)"
  fi
  ln -sv "${ZQS_ZSH_FUNCTIONS_REL}" "${TARGET_ZSH_FUNCTIONS_LINK}"
fi

# Read-only verification of quickstart-managed files required by upstream zsh init.
missing_required=0
for required_file in \
  "${TARGET_ZSHRC_LINK}" \
  "${TARGET_ZGEN_SETUP_LINK}" \
  "${TARGET_ZSH_FUNCTIONS_LINK}"
do
  if [[ ! -e "${required_file}" ]]; then
    warn "Required quickstart file is missing: ${required_file}"
    missing_required=1
  fi
done
unset required_file

if [[ "${missing_required}" -ne 0 ]]; then
  warn "Quickstart setup is incomplete. Re-run: ${HOME}/Developer/dotfiles/scripts/install-zsh-quickstart.sh"
fi

if [[ ! -e "${ZGENOM_INIT_FILE}" ]]; then
  warn "zgenom init cache not found at ${ZGENOM_INIT_FILE}. Completions may be unavailable until it is generated."
  warn "Open a new shell to trigger generation, or run: zsh -lic 'zgenom reset; zgenom save'"
fi
