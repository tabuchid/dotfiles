# Put Homebrew first in PATH.
#
# brew shellenv runs in .zshenv (prepends /opt/homebrew/{bin,sbin}), but macOS's
# /etc/zprofile then runs path_helper, which rebuilds PATH from /etc/paths{,.d}
# and shoves /usr/bin et al. back in front of Homebrew. The zsh-quickstart-kit
# only *appends* /opt/homebrew/bin, so it loses too. Result: `brew doctor` warns
# that /usr/bin occurs before /opt/homebrew/bin and system tools shadow brew's.
#
# This drop-in re-runs brew shellenv late (after path_helper, after the kit's
# PATH block). brew shellenv *prepends*, so Homebrew wins. The kit's
# `typeset -aU path` dedupe (later in .zshrc) keeps this earlier occurrence and
# strips the appended duplicate. Lives in ~/.zshrc.d so it survives kit updates.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
