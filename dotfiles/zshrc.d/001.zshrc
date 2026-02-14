export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@15/lib/pkgconfig"

# pnpm
export PNPM_HOME="/Users/doug/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



# Cursor and Code CLI shortcuts
alias cursor="open -a Cursor"
alias code="open -a Visual\ Studio\ Code"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"


if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export GIT_PAGER=cat
fi


[ -f "${0:a:h}/secrets.zshrc" ] && source "${0:a:h}/secrets.zshrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# eval "$(~/.local/bin/cursor-agent shell-integration zsh)"

export PATH="/Applications/SnowSQL.app/Contents/MacOS:$PATH"
# opencode
export PATH=/Users/doug/.opencode/bin:$PATH

# bun completions
[ -s "/Users/doug/.bun/_bun" ] && source "/Users/doug/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# mise - use shims so project/tool versions take precedence over Homebrew/system bins
if command -v mise >/dev/null 2>&1; then
  mise_bin="$(whence -p mise 2>/dev/null)"
  eval "$(mise activate zsh --shims)"

  # Keep mise completion available without depending on the OMZ mise plugin.
  mise_comp_dir="${ZSH_CACHE_DIR:-$HOME/.zsh/cache}/completions"
  mkdir -p "$mise_comp_dir"

  if [[ ! -s "$mise_comp_dir/_mise" || ( -n "$mise_bin" && "$mise_bin" -nt "$mise_comp_dir/_mise" ) ]]; then
    mise completion zsh >| "$mise_comp_dir/_mise"
  fi

  fpath=("$mise_comp_dir" $fpath)
  autoload -Uz _mise
  compdef _mise mise

  unset mise_bin
  unset mise_comp_dir
fi
