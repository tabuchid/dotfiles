export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@15/lib/pkgconfig"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



# Cursor and Code CLI shortcuts
alias cursor="open -a Cursor"
alias code="open -a Visual\ Studio\ Code"

# Initialize the completion system before any tool emits `#compdef ...` scripts
# via eval. uv/uvx/mise completions below rely on `compdef` being defined.
fpath=(/Users/doug/.docker/completions $fpath)
autoload -Uz compinit
compinit

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"


if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export GIT_PAGER=cat
fi


[ -f "${0:a:h}/secrets.zshrc" ] && source "${0:a:h}/secrets.zshrc"

# fzf integration. We bypass ~/.fzf.zsh (Homebrew-generated, ignored via
# zqs-settings/load-fzf-zsh-plugin=false) and load fzf ourselves so we can
# filter its options snapshot. fzf's `--zsh` output saves shell options into
# `options=(${(j: :)${(kv)options[@]}})` and later evals that string to restore
# them. Recent zsh treats `zle` as a read-only state option, so the eval errors
# with "can't change option: zle". Rewrite the snapshot-builder to drop the
# `zle <state>` pair before stringifying.
if command -v fzf >/dev/null 2>&1; then
  source <(
    fzf --zsh | perl -pe '
      s{
        ^(\s*)(__fzf_(?:key_bindings|completion)_options)="options=\(\$\{\(j:\ :\)\$\{\(kv\)options\[\@\]\}\}\)"
      }{
        $1 . "{ local -a _fzf_opts=(\"\${(kv)options[\@]}\"); local _fzf_i=\${_fzf_opts[(i)zle]}; (( _fzf_i <= \${#_fzf_opts} )) && _fzf_opts[_fzf_i,_fzf_i+1]=(); $2=\"options=(\${(j: :)_fzf_opts})\"; }"
      }xe;
    '
  )
fi

# zoxide provides the `z` shell command/function.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# eval "$(~/.local/bin/cursor-agent shell-integration zsh)"

export PATH="/Applications/SnowSQL.app/Contents/MacOS:$PATH"
# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# mise - hook-based activation ensures project tool versions take precedence
if command -v mise >/dev/null 2>&1; then
  mise_bin="$(whence -p mise 2>/dev/null)"
  eval "$(mise activate zsh)"

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

alias lg='lazygit'

# Docker CLI completions: fpath entry is added at the top of this file, where
# compinit runs. Nothing else needed here.

# Gangway tab completion
[ -f "/Users/doug/.config/gangway/completions.zsh" ] && source "/Users/doug/.config/gangway/completions.zsh"
