#!/usr/bin/env bash
set -euo pipefail

log() { printf "[codex] %s\n" "$*"; }

cleanup_legacy_shim() {
  local chatgpt_codex="/Applications/ChatGPT.app/Contents/Resources/codex"
  local bin_path="${HOME}/.local/bin/codex"
  local legacy_alias="${HOME}/.local/bin/codex-cli"

  if [[ -L "${bin_path}" && "$(readlink "${bin_path}")" == "${chatgpt_codex}" ]]; then
    log "Removing legacy ChatGPT app Codex shim at ${bin_path}"
    rm -f "${bin_path}"
  fi

  if [[ -L "${legacy_alias}" && "$(readlink "${legacy_alias}")" == "${chatgpt_codex}" ]]; then
    log "Removing legacy Codex alias at ${legacy_alias}"
    rm -f "${legacy_alias}"
  fi
}

cleanup_legacy_shim

log "Installing Codex CLI with the official installer"
curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=true sh
