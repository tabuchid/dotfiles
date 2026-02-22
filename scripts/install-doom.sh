#!/usr/bin/env bash
set -euo pipefail

# NOTE: If you need to re-install emacs-plus (e.g. to change build flags):
#   brew uninstall emacs-plus@30
#   brew install d12frosted/emacs-plus/emacs-plus@30 --with-dbus --with-imagemagick --with-mailutils --with-xwidgets
#   Never use `brew reinstall` — it can fail during source builds.
#   Then run: doom sync
#   If changing major versions (e.g. @29 -> @30), also run: doom build

log() { printf "[doom] %s\n" "$*"; }

EMACS_DIR="$HOME/.config/emacs"
DOOM_REPO="https://github.com/doomemacs/doomemacs"
DOOM_BIN="$EMACS_DIR/bin/doom"
USER_DOOM_DIR_XDG="$HOME/.config/doom"
USER_DOOM_DIR_LEGACY="$HOME/.doom.d"
FRESH_INSTALL=false

if [[ ! -d "$EMACS_DIR/.git" ]]; then
  FRESH_INSTALL=true
  if [[ -d "$EMACS_DIR" ]]; then
    log "Backing up existing $EMACS_DIR"
    mv -v "$EMACS_DIR" "$EMACS_DIR.bak.$(date +%s)"
  fi
  log "Cloning Doom Emacs into $EMACS_DIR"
  git clone --depth 1 "$DOOM_REPO" "$EMACS_DIR"
else
  log "Doom Emacs repo exists"
fi

if [[ "$FRESH_INSTALL" == true && -d "$USER_DOOM_DIR_LEGACY" && ! -e "$USER_DOOM_DIR_XDG" ]]; then
  mkdir -p "$(dirname "$USER_DOOM_DIR_XDG")"
  log "Migrating Doom config from $USER_DOOM_DIR_LEGACY to $USER_DOOM_DIR_XDG"
  mv -v "$USER_DOOM_DIR_LEGACY" "$USER_DOOM_DIR_XDG"
fi

if [[ ! -x "$DOOM_BIN" ]]; then
  log "Doom CLI not found at $DOOM_BIN"
  exit 0
fi

export DOOMDIR="$USER_DOOM_DIR_XDG"

if [[ "$FRESH_INSTALL" == true ]]; then
  log "Running doom install"
  # Newer Doom CLI uses -! / --force instead of legacy -y.
  "$DOOM_BIN" install -! || true
else
  log "Running doom upgrade"
  "$DOOM_BIN" upgrade -! || true
fi
