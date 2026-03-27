# Override eza plugin's ls alias to include color and classify (directory indicators)
if (( $+commands[eza] )); then
  alias ls='eza --color=auto --classify --group-directories-first --git'
fi
