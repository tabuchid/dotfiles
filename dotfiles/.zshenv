eval "$(/opt/homebrew/bin/brew shellenv)"

# Drop stale fpath dirs and restore the current zsh's functions dir
fpath=( ${^fpath}(N-/) )
fpath=( /opt/homebrew/opt/zsh/share/zsh/functions $fpath )
typeset -U fpath

# uv
export PATH="/Users/doug/.local/bin:$PATH"
