#!/usr/bin/env bash
set -euo pipefail

log() { printf "[doom] %s\n" "$*"; }

EMACS_DIR="$HOME/.emacs.d"
DOOM_REPO="https://github.com/hlissner/doom-emacs"
DOOM_BIN="$EMACS_DIR/bin/doom"
USER_DOOM_DIR="$HOME/.doom.d"

# Ensure doom-emacs repo is present
if [[ ! -d "$EMACS_DIR/.git" ]]; then
  if [[ -d "$EMACS_DIR" ]]; then
    log "Backing up existing $EMACS_DIR"
    mv -v "$EMACS_DIR" "$EMACS_DIR.bak.$(date +%s)"
  fi
  log "Cloning Doom Emacs into $EMACS_DIR"
  git clone --depth 1 "$DOOM_REPO" "$EMACS_DIR"
else
  log "Doom Emacs repo exists; updating"
  git -C "$EMACS_DIR" pull --ff-only || true
fi

if [[ ! -x "$DOOM_BIN" ]]; then
  log "Doom CLI not found at $DOOM_BIN"
  exit 0
fi

# Run a non-interactive sync (safe if ~/.doom.d is not yet present)
log "Running doom sync"
"$DOOM_BIN" -y sync || true
