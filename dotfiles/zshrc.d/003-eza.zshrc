# Override ls/ll aliases to use eza instead of gls
# EZA_COLORS=reset makes eza ignore LS_COLORS and use theme.yml instead.
# Without this, LS_COLORS (set by zsh-quickstart-kit) takes priority over theme.yml.
#
# We resolve the full path to eza at alias-definition time via ${commands[eza]}
# so the alias works even if PATH is later stripped (e.g. Claude Code's Bash tool).
if (( $+commands[eza] )); then
  export EZA_CONFIG_DIR="$HOME/.config/eza"
  export EZA_COLORS="reset"
  alias ls="${commands[eza]} --color=auto --classify --group-directories-first --git"
  alias ll="${commands[eza]} -la --color=auto --classify --group-directories-first --git"
fi
