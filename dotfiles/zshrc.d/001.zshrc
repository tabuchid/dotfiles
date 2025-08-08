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