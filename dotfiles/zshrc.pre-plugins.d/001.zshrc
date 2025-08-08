typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  POWERLEVEL9K_INSTANT_PROMPT=off
fi
