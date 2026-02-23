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

install_symbols_nerd_font() {
  if ! need_cmd brew; then
    log "brew not found; skipping Symbols Nerd Font install"
    return 0
  fi

  if brew list --cask font-symbols-only-nerd-font >/dev/null 2>&1; then
    log "Symbols Nerd Font cask already installed"
    return 0
  fi

  log "Installing Symbols Nerd Font (Symbols Only) cask"
  brew install --cask font-symbols-only-nerd-font
}

install_symbola_font() {
  local page_url="https://fontlibrary.org/en/font/symbola"
  local zip_url
  local zip_path
  local tmpdir
  local fonts_dir="${HOME}/Library/Fonts"

  if compgen -G "${HOME}/Library/Fonts/Symbola*.ttf" >/dev/null; then
    log "Symbola font already present in ${HOME}/Library/Fonts"
    return 0
  fi
  if compgen -G "/Library/Fonts/Symbola*.ttf" >/dev/null; then
    log "Symbola font already present in /Library/Fonts"
    return 0
  fi

  if ! need_cmd curl; then
    log "curl not found; skipping Symbola font install"
    return 0
  fi

  if ! need_cmd unzip; then
    log "unzip not found; skipping Symbola font install"
    return 0
  fi

  log "Resolving Symbola font download URL"
  zip_path="$(curl -fsSL "${page_url}" | grep -Eo '/assets/downloads/symbola/[^"]+/symbola\.zip' | head -1 || true)"
  if [[ -n "${zip_path}" ]]; then
    zip_url="https://fontlibrary.org${zip_path}"
  else
    zip_url="$(curl -fsSL "${page_url}" | grep -Eo 'https://fontlibrary\.org/assets/downloads/symbola/[^"]+/symbola\.zip' | head -1 || true)"
  fi
  if [[ -z "${zip_url}" ]]; then
    log "Could not resolve Symbola download URL; skipping"
    return 0
  fi

  tmpdir="$(mktemp -d)"
  mkdir -p "${fonts_dir}"

  log "Downloading Symbola font archive"
  curl -fsSL "${zip_url}" -o "${tmpdir}/symbola.zip"
  unzip -oq "${tmpdir}/symbola.zip" -d "${tmpdir}/unzipped"

  if compgen -G "${tmpdir}/unzipped/*.ttf" >/dev/null; then
    cp -f "${tmpdir}/unzipped/"*.ttf "${fonts_dir}/"
    log "Installed Symbola font files into ${fonts_dir}"
  else
    log "No TTF files found in Symbola archive; skipping"
  fi

  rm -rf "${tmpdir}"
}

install_doom_fonts() {
  install_symbols_nerd_font || log "Symbols Nerd Font install failed; continuing"
  install_symbola_font || log "Symbola font install failed; continuing"
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
  install_doom_fonts
  install_dockfmt_shim
  install_mise_node_tools
  install_uv_tools
}

main "$@"
