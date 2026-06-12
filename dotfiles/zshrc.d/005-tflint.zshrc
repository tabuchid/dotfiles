# tflint is installed MANUALLY, not via Homebrew.
#
# The terraform-linters/tflint Homebrew tap was deleted upstream (404), and
# tflint is not in homebrew-core, so `brew upgrade` will NOT update it. The
# project now ships official release binaries on GitHub instead. The binary
# lives in ~/.local/bin (early on PATH via .zshenv).
#
# Run `update-tflint` to pull the latest release. Check the installed version
# with `tflint --version`; releases: https://github.com/terraform-linters/tflint/releases
update-tflint() {
  emulate -L zsh
  set -e
  local arch="arm64"  # this machine is Apple Silicon
  local tmp; tmp="$(mktemp -d)"
  local tag
  echo "Resolving latest tflint release…"
  tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
    https://github.com/terraform-linters/tflint/releases/latest \
    | sed 's#.*/tag/##')"
  if [[ -z "$tag" ]]; then echo "could not resolve latest tag" >&2; return 1; fi
  echo "Latest: $tag  (installed: $(tflint --version 2>/dev/null | head -1))"
  echo "Downloading tflint_darwin_${arch}.zip…"
  curl -fsSL -o "$tmp/tflint.zip" \
    "https://github.com/terraform-linters/tflint/releases/download/${tag}/tflint_darwin_${arch}.zip"
  unzip -oq "$tmp/tflint.zip" -d "$tmp"
  mkdir -p "$HOME/.local/bin"
  mv "$tmp/tflint" "$HOME/.local/bin/tflint"
  chmod +x "$HOME/.local/bin/tflint"
  rm -rf "$tmp"
  hash -r 2>/dev/null
  echo "Installed: $(tflint --version 2>/dev/null | head -1) -> $(command -v tflint)"
}
