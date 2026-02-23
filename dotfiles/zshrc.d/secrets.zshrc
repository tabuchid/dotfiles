typeset -g DOTFILES_SECRETS_CACHE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/secrets.1password.env.zsh"

if [[ -r "${DOTFILES_SECRETS_CACHE_FILE}" ]]; then
  source "${DOTFILES_SECRETS_CACHE_FILE}"
fi

sync_dotfiles_secrets() {
  local repo_script

  for repo_script in \
    "$HOME/Developer/dotfiles/scripts/sync-op-secrets.sh" \
    "$HOME/Development/dotfiles/scripts/sync-op-secrets.sh"
  do
    if [[ -x "${repo_script}" ]]; then
      "${repo_script}" "$@" || return $?
      source "${DOTFILES_SECRETS_CACHE_FILE}"
      return 0
    fi
  done

  print -u2 "sync_dotfiles_secrets: sync-op-secrets.sh not found in ~/Developer/dotfiles or ~/Development/dotfiles"
  return 1
}
