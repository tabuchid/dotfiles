# Agent shells get plain commands: Claude Code snapshots this interactive config
# into its Bash tool, where an alias that shadows a real command (ls -> eza,
# gcp -> git cherry-pick, ssh -> ssh -A, md5sum -> md5) breaks the flags and
# output agents expect. Aliases with no command of the same name stay.
if [[ -n ${CLAUDECODE:-} ]]; then
  () {
    local name
    for name in ${(k)aliases}; do
      (( $+commands[$name] )) && unalias -- "$name"
    done
  }
fi
