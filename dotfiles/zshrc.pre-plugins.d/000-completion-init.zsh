# Post-startup check to ensure compdef exists after zgenom/compinit runs.
# We defer to the first prompt (precmd) so normal initialization can finish.
autoload -Uz add-zsh-hook

__zqs_check_compdef_after_init() {
  if ! (( $+functions[compdef] )); then
    echo ""
    echo "WARNING: compdef is not available after init. This usually means ~/.zgenom/init.zsh needs to be regenerated."
    echo ""
    echo "To fix this, run:"
    echo "  zgenom reset"
    echo "  zgenom save"
    echo ""
    echo "Or start a new shell session to trigger automatic regeneration."
    echo ""
  fi
  add-zsh-hook -d precmd __zqs_check_compdef_after_init
}

add-zsh-hook precmd __zqs_check_compdef_after_init

