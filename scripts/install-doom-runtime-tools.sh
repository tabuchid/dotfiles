#!/usr/bin/env bash
set -euo pipefail

log() { printf "[doom-tools] %s\n" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }

ensure_local_bin() {
  mkdir -p "${HOME}/.local/bin"
}

ensure_symlink() {
  local target="$1"
  local link_path="$2"

  ensure_local_bin
  ln -snf "${target}" "${link_path}"
}

install_uv_tools() {
  local tool
  local -a tools=(
    black
    pyflakes
    isort
    pipenv
    pytest
    nose
  )

  if ! need_cmd uv; then
    log "uv not found; skipping Python CLI installs"
    return 0
  fi

  for tool in "${tools[@]}"; do
    log "Ensuring uv tool '${tool}'"
    uv tool install --upgrade "${tool}"
  done
}

install_mise_node_tools() {
  local stylelint_bin
  local js_beautify_bin
  local -a npm_packages=(stylelint js-beautify)

  if ! need_cmd mise; then
    log "mise not found; skipping Node runtime and npm global installs"
    return 0
  fi

  if [[ -f "${HOME}/.config/mise/config.toml" ]]; then
    log "Installing runtimes from ~/.config/mise/config.toml"
    mise install
  else
    log "No ~/.config/mise/config.toml found; skipping 'mise install'"
  fi

  log "Ensuring npm globals for Doom web tooling: ${npm_packages[*]}"
  mise exec -- npm install -g "${npm_packages[@]}"

  stylelint_bin="$(mise exec -- which stylelint)"
  js_beautify_bin="$(mise exec -- which js-beautify)"
  ensure_symlink "${stylelint_bin}" "${HOME}/.local/bin/stylelint"
  ensure_symlink "${js_beautify_bin}" "${HOME}/.local/bin/js-beautify"
}

install_dockfmt_shim() {
  local dockerfmt_bin

  if ! need_cmd dockerfmt; then
    log "dockerfmt not found; skipping dockfmt shim"
    return 0
  fi

  dockerfmt_bin="$(command -v dockerfmt)"
  ensure_symlink "${dockerfmt_bin}" "${HOME}/.local/bin/dockfmt"
}

main() {
  install_dockfmt_shim
  install_mise_node_tools
  install_uv_tools
}

main "$@"
