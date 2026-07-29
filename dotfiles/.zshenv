eval "$(/opt/homebrew/bin/brew shellenv)"

# Drop stale fpath dirs and restore the current zsh's functions dir
fpath=( ${^fpath}(N-/) )
fpath=( /opt/homebrew/opt/zsh/share/zsh/functions $fpath )
typeset -U fpath

# uv
export PATH="/Users/doug/.local/bin:$PATH"

# 1Password secret cache
DOTFILES_SECRETS_CACHE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/secrets.1password.env.zsh"
if [[ -r "${DOTFILES_SECRETS_CACHE_FILE}" ]]; then
  source "${DOTFILES_SECRETS_CACHE_FILE}"
fi
