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
DOOM_REPO="https://github.com/doomemacs/core"
DOOM_BIN="$EMACS_DIR/bin/doom"
USER_DOOM_DIR_XDG="$HOME/.config/doom"
USER_DOOM_DIR_LEGACY="$HOME/.doom.d"
LEGACY_EMACS_DIR="$HOME/.emacs.d"
FRESH_INSTALL=false

# Writes the thin redirect shim only if the target is missing or differs, so a
# stale file (e.g. a verbatim copy of Doom's own early-init.el left over from a
# previous install) gets corrected instead of silently kept. A stale copy of
# Doom's bootstrapper here boots Doom in the wrong order and crashes startup
# with "(void-variable doom-modules)".
write_shim() {
  local target="$1" desired="$2"
  if [[ -e "$target" ]] && [[ "$(cat "$target")" == "$desired" ]]; then
    return 0
  fi
  if [[ -e "$target" ]]; then
    local backup="${target}.bak-$(date +%Y%m%d%H%M%S)"
    log "Replacing stale $target (backup: $backup)"
    cp "$target" "$backup"
  else
    log "Creating $target bootstrap to load Doom from ~/.config/emacs"
  fi
  printf '%s\n' "$desired" >"$target"
}

ensure_xdg_emacs_bootstrap() {
  local early_init="${LEGACY_EMACS_DIR}/early-init.el"
  local init_file="${LEGACY_EMACS_DIR}/init.el"

  [[ -d "$LEGACY_EMACS_DIR" ]] || return 0
  [[ -L "$LEGACY_EMACS_DIR" ]] && return 0

  write_shim "$early_init" ';; Bootstrap Doom Emacs from XDG config when ~/.emacs.d exists.
(setq user-emacs-directory (expand-file-name "~/.config/emacs/"))
(let ((bootstrap (expand-file-name "early-init.el" user-emacs-directory)))
  (when (file-exists-p bootstrap)
    (load bootstrap nil '\''nomessage)))'

  write_shim "$init_file" ';; Bootstrap Doom Emacs from XDG config when ~/.emacs.d exists.
(setq user-emacs-directory (expand-file-name "~/.config/emacs/"))
(let ((bootstrap (expand-file-name "init.el" user-emacs-directory)))
  (when (file-exists-p bootstrap)
    (load bootstrap nil '\''nomessage)))'
}

if [[ ! -d "$EMACS_DIR/.git" ]]; then
  FRESH_INSTALL=true
  if [[ -d "$EMACS_DIR" ]]; then
    log "Backing up existing $EMACS_DIR"
    mv -v "$EMACS_DIR" "$EMACS_DIR.bak.$(date +%s)"
  fi
  log "Cloning Doom Emacs into $EMACS_DIR"
  # --recurse-submodules pulls sources/doom+ (the doomemacs/modules submodule);
  # since v2.1 modules live in a separate repo and are missing without this.
  git clone --depth 1 --recurse-submodules "$DOOM_REPO" "$EMACS_DIR"
else
  log "Doom Emacs repo exists"
  # Ensure the modules submodule is present/updated on existing installs too.
  git -C "$EMACS_DIR" submodule update --init --recursive || true
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
ensure_xdg_emacs_bootstrap

if [[ "$FRESH_INSTALL" == true ]]; then
  log "Running doom install"
  # Newer Doom CLI uses -! / --force instead of legacy -y.
  "$DOOM_BIN" install -! || true
else
  log "Running doom upgrade"
  "$DOOM_BIN" upgrade -! || true
fi
