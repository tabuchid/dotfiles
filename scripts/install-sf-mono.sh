#!/usr/bin/env bash
set -euo pipefail

log() { printf "[fonts] %s\n" "$*"; }

SOURCE_DIRS=(
  "/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
  "/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
)

TARGET_DIR="${HOME}/Library/Fonts"

find_source_dir() {
  local dir
  for dir in "${SOURCE_DIRS[@]}"; do
    if [[ -d "${dir}" ]]; then
      printf '%s\n' "${dir}"
      return 0
    fi
  done
  return 1
}

copy_if_needed() {
  local src="$1"
  local dest="$2"

  if [[ -f "${dest}" ]] && cmp -s "${src}" "${dest}"; then
    return 1
  fi

  cp -f "${src}" "${dest}"
  return 0
}

main() {
  local source_dir
  if ! source_dir="$(find_source_dir)"; then
    log "SF Mono source fonts not found in Terminal.app resources; skipping (non-fatal)"
    return 0
  fi

  mkdir -p "${TARGET_DIR}"

  local patterns=("SF-Mono-*.otf" "SFMono*-Terminal.ttf")
  local pattern src basename dest
  local matched=0 installed=0 skipped=0

  shopt -s nullglob
  for pattern in "${patterns[@]}"; do
    for src in "${source_dir}"/${pattern}; do
      matched=$((matched + 1))
      basename="$(basename "${src}")"
      dest="${TARGET_DIR}/${basename}"
      if copy_if_needed "${src}" "${dest}"; then
        installed=$((installed + 1))
        log "Installed ${basename}"
      else
        skipped=$((skipped + 1))
      fi
    done
  done
  shopt -u nullglob

  if (( matched == 0 )); then
    log "No SF Mono font files found in ${source_dir}; skipping (non-fatal)"
    return 0
  fi

  log "SF Mono install summary: installed=${installed} skipped=${skipped} target=${TARGET_DIR}"
}

main "$@"
