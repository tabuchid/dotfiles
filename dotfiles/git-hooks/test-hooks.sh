#!/bin/bash
# Throwaway-repo tests for the global agent git hooks.
# Scrubs HERMES_AGENT, CLAUDECODE, AGENT_TOOL, and every CODEX_* variable
# so a Hermes session can run this script as-is.
set -u
set -o pipefail

HOOKS_DIR=$(CDPATH='' cd "$(dirname "$0")" && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/agent-git-hooks.XXXXXX")
GIT_CONFIG_GLOBAL="$TMP/gitconfig"
failures=0

cat >"$GIT_CONFIG_GLOBAL" <<EOF
[user]
	name = Test User
	email = test@example.com
[core]
	hooksPath = $HOOKS_DIR
[init]
	defaultBranch = main
[commit]
	gpgsign = false
EOF

# Invoked via trap on EXIT.
# shellcheck disable=SC2329
cleanup() {
  if [ "$failures" -eq 0 ]; then
    rm -rf "$TMP"
  else
    printf 'kept temp dir: %s\n' "$TMP" >&2
  fi
}
trap cleanup EXIT

scrubbed() {
  local -a cmd
  cmd=(
    env -i
    "PATH=$PATH"
    "HOME=$HOME"
    "TMPDIR=${TMPDIR:-/tmp}"
    "LANG=${LANG:-C}"
    "GIT_CONFIG_GLOBAL=$GIT_CONFIG_GLOBAL"
    "GIT_CONFIG_NOSYSTEM=1"
  )
  while [ $# -gt 0 ]; do
    case "$1" in
      *=*)
        cmd+=("$1")
        shift
        ;;
      *)
        break
        ;;
    esac
  done
  "${cmd[@]}" "$@"
}

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  if [ -n "${2:-}" ]; then
    printf '  detail: %s\n' "$2"
  fi
  failures=$((failures + 1))
}

make_repo() {
  local branch="$1"
  local dir
  dir=$(mktemp -d "$TMP/repo.XXXXXX")
  scrubbed git init -q -b "$branch" "$dir" || return 1
  scrubbed git -C "$dir" commit -q --allow-empty -m "init" || return 1
  printf '%s\n' "$dir"
}

commit_status() {
  # commit_status <dir> <outfile> [ENV=val ...] -- git commit args...
  local dir="$1"
  local outfile="$2"
  shift 2
  local -a prefix
  prefix=()
  while [ $# -gt 0 ]; do
    case "$1" in
      --)
        shift
        break
        ;;
      *=*)
        prefix+=("$1")
        shift
        ;;
      *)
        printf 'bad commit_status args\n' >&2
        return 2
        ;;
    esac
  done
  if [ "${#prefix[@]}" -eq 0 ]; then
    scrubbed git -C "$dir" "$@" >"$outfile" 2>&1
  else
    scrubbed "${prefix[@]}" git -C "$dir" "$@" >"$outfile" 2>&1
  fi
}

trailer_lines() {
  local dir="$1"
  scrubbed git -C "$dir" log -1 --format=%B | grep -c '^Agent:' || true
}

trailer_value() {
  local dir="$1"
  scrubbed git -C "$dir" log -1 --format=%B | grep '^Agent:' || true
}

head_of() {
  scrubbed git -C "$1" rev-parse HEAD
}

printf 'parent HERMES_AGENT=%s\n' "${HERMES_AGENT-<unset>}"

# 1. human commit on main is allowed, with no trailer
dir=$(make_repo main) || fail "1 setup" "make_repo failed"
if [ -n "${dir:-}" ]; then
  out="$TMP/1.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" -- commit --allow-empty -m "human on main"; then
    count=$(trailer_lines "$dir")
    if [ "$count" -eq 0 ] && [ "$(head_of "$dir")" != "$before" ]; then
      pass "1 human commit on main allowed, no trailer"
    else
      fail "1 human commit on main allowed, no trailer" "trailers=$count"
    fi
  else
    fail "1 human commit on main allowed, no trailer" "$(cat "$out")"
  fi
fi

# 2. AGENT_TOOL=codex on main is refused
dir=$(make_repo main) || fail "2 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/2.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" AGENT_TOOL=codex -- commit --allow-empty -m "codex on main"; then
    fail "2 AGENT_TOOL=codex on main refused" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ] && grep -q 'refusing agent (codex) commit on main' "$out"; then
    pass "2 AGENT_TOOL=codex on main refused"
  else
    fail "2 AGENT_TOOL=codex on main refused" "$(cat "$out")"
  fi
fi

# 3. HERMES_AGENT=true on main is refused
dir=$(make_repo main) || fail "3 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/3.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "hermes on main"; then
    fail "3 HERMES_AGENT=true on main refused" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ]; then
    pass "3 HERMES_AGENT=true on main refused"
  else
    fail "3 HERMES_AGENT=true on main refused" "$(cat "$out")"
  fi
fi

# 4. CLAUDECODE=1 on main is refused
dir=$(make_repo main) || fail "4 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/4.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" CLAUDECODE=1 -- commit --allow-empty -m "claude on main"; then
    fail "4 CLAUDECODE=1 on main refused" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ]; then
    pass "4 CLAUDECODE=1 on main refused"
  else
    fail "4 CLAUDECODE=1 on main refused" "$(cat "$out")"
  fi
fi

# 5. agent on branch agent/hermes/x is allowed and gets the Agent: hermes trailer
dir=$(make_repo main) || fail "5 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/5.out"
  scrubbed git -C "$dir" checkout -q -b agent/hermes/x
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "feature work"; then
    count=$(trailer_lines "$dir")
    value=$(trailer_value "$dir")
    if [ "$count" -eq 1 ] && [ "$value" = "Agent: hermes" ]; then
      pass "5 agent on agent/hermes/x allowed with Agent: hermes trailer"
    else
      fail "5 agent on agent/hermes/x allowed with Agent: hermes trailer" "count=$count value=$value body=$(scrubbed git -C "$dir" log -1 --format=%B)"
    fi
  else
    fail "5 agent on agent/hermes/x allowed with Agent: hermes trailer" "$(cat "$out")"
  fi
fi

# 6. agent in a linked worktree branch is allowed, with the trailer
dir=$(make_repo main) || fail "6 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/6.out"
  wt=$(mktemp -d "$TMP/wt.XXXXXX")
  if scrubbed git -C "$dir" worktree add -q -b agent/hermes/linked "$wt"; then
    if commit_status "$wt" "$out" HERMES_AGENT=true -- commit --allow-empty -m "worktree commit"; then
      count=$(trailer_lines "$wt")
      value=$(trailer_value "$wt")
      if [ "$count" -eq 1 ] && [ "$value" = "Agent: hermes" ]; then
        pass "6 agent in linked worktree allowed with trailer"
      else
        fail "6 agent in linked worktree allowed with trailer" "count=$count value=$value"
      fi
    else
      fail "6 agent in linked worktree allowed with trailer" "$(cat "$out")"
    fi
  else
    fail "6 agent in linked worktree allowed with trailer" "worktree add failed"
  fi
fi

# 7. AGENT_ALLOW_MAIN=1 is allowed
dir=$(make_repo main) || fail "7 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/7.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" AGENT_TOOL=codex AGENT_ALLOW_MAIN=1 -- commit --allow-empty -m "allow env"; then
    if [ "$(head_of "$dir")" != "$before" ]; then
      pass "7 AGENT_ALLOW_MAIN=1 allowed"
    else
      fail "7 AGENT_ALLOW_MAIN=1 allowed" "HEAD unchanged"
    fi
  else
    fail "7 AGENT_ALLOW_MAIN=1 allowed" "$(cat "$out")"
  fi
fi

# 8. git config agent.allowMainCommits true is allowed
dir=$(make_repo main) || fail "8 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/8.out"
  before=$(head_of "$dir")
  scrubbed git -C "$dir" config agent.allowMainCommits true
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "allow config"; then
    if [ "$(head_of "$dir")" != "$before" ]; then
      pass "8 git config agent.allowMainCommits true allowed"
    else
      fail "8 git config agent.allowMainCommits true allowed" "HEAD unchanged"
    fi
  else
    fail "8 git config agent.allowMainCommits true allowed" "$(cat "$out")"
  fi
fi

# 9. an existing Agent: trailer is not duplicated
dir=$(make_repo main) || fail "9 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/9.out"
  scrubbed git -C "$dir" checkout -q -b agent/hermes/existing
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "subject" -m "Agent: hermes"; then
    count=$(trailer_lines "$dir")
    if [ "$count" -eq 1 ]; then
      pass "9 existing Agent trailer not duplicated"
    else
      fail "9 existing Agent trailer not duplicated" "count=$count body=$(scrubbed git -C "$dir" log -1 --format=%B)"
    fi
  else
    fail "9 existing Agent trailer not duplicated" "$(cat "$out")"
  fi
fi

# 10. a repo-local .git/hooks/pre-commit that exits 1 still blocks, human and agent
dir=$(make_repo main) || fail "10 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/10.out"
  cat >"$dir/.git/hooks/pre-commit" <<'EOF'
#!/bin/sh
echo chained-pre-commit >&2
exit 1
EOF
  chmod +x "$dir/.git/hooks/pre-commit"
  before=$(head_of "$dir")
  human_blocked=0
  agent_blocked=0
  if commit_status "$dir" "$out" -- commit --allow-empty -m "human chained"; then
    fail "10 repo-local pre-commit blocks human" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ] && grep -q 'chained-pre-commit' "$out"; then
    human_blocked=1
    pass "10 repo-local pre-commit blocks human"
  else
    fail "10 repo-local pre-commit blocks human" "$(cat "$out")"
  fi
  scrubbed git -C "$dir" checkout -q -b agent/hermes/chained
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "agent chained"; then
    fail "10 repo-local pre-commit blocks agent" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ] && grep -q 'chained-pre-commit' "$out"; then
    agent_blocked=1
    pass "10 repo-local pre-commit blocks agent"
  else
    fail "10 repo-local pre-commit blocks agent" "$(cat "$out")"
  fi
  if [ "$human_blocked" -eq 1 ] && [ "$agent_blocked" -eq 1 ]; then
    :
  fi
fi

# 11. a repo-local prepare-commit-msg still runs
dir=$(make_repo main) || fail "11 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/11.out"
  cat >"$dir/.git/hooks/prepare-commit-msg" <<'EOF'
#!/bin/sh
printf '\nChained-hook: ran\n' >> "$1"
EOF
  chmod +x "$dir/.git/hooks/prepare-commit-msg"
  scrubbed git -C "$dir" checkout -q -b agent/hermes/msg
  if commit_status "$dir" "$out" HERMES_AGENT=true -- commit --allow-empty -m "chain message"; then
    body=$(scrubbed git -C "$dir" log -1 --format=%B)
    if printf '%s\n' "$body" | grep -q '^Agent: hermes$' && printf '%s\n' "$body" | grep -q '^Chained-hook: ran$'; then
      pass "11 repo-local prepare-commit-msg still runs"
    else
      fail "11 repo-local prepare-commit-msg still runs" "$body"
    fi
  else
    fail "11 repo-local prepare-commit-msg still runs" "$(cat "$out")"
  fi
fi

# 12. on master, an agent is refused
dir=$(make_repo master) || fail "12 setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/12.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" AGENT_TOOL=grok -- commit --allow-empty -m "grok on master"; then
    fail "12 agent on master refused" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ] && grep -q 'refusing agent (grok) commit on master' "$out"; then
    pass "12 agent on master refused"
  else
    fail "12 agent on master refused" "$(cat "$out")"
  fi
fi

# Extra: CODEX_HOME alone is not a Codex signal (human on main still allowed).
dir=$(make_repo main) || fail "extra CODEX_HOME setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/home.out"
  if commit_status "$dir" "$out" CODEX_HOME="$HOME/.codex" -- commit --allow-empty -m "codex home only"; then
    count=$(trailer_lines "$dir")
    if [ "$count" -eq 0 ]; then
      pass "extra CODEX_HOME alone does not mark a commit as codex"
    else
      fail "extra CODEX_HOME alone does not mark a commit as codex" "trailers=$count"
    fi
  else
    fail "extra CODEX_HOME alone does not mark a commit as codex" "$(cat "$out")"
  fi
fi

# Extra: verified sandbox signal refuses main.
dir=$(make_repo main) || fail "extra CODEX_SANDBOX setup"
if [ -n "${dir:-}" ]; then
  out="$TMP/sandbox.out"
  before=$(head_of "$dir")
  if commit_status "$dir" "$out" CODEX_SANDBOX=seatbelt -- commit --allow-empty -m "sandboxed codex"; then
    fail "extra CODEX_SANDBOX=seatbelt on main refused" "commit succeeded"
  elif [ "$(head_of "$dir")" = "$before" ]; then
    pass "extra CODEX_SANDBOX=seatbelt on main refused"
  else
    fail "extra CODEX_SANDBOX=seatbelt on main refused" "$(cat "$out")"
  fi
fi

# 13. pass-through: repo-local pre-push (gets stdin), post-commit and post-merge still run
dir=$(make_repo main) || fail "13 setup"
if [ -n "${dir:-}" ]; then
  remote="$TMP/remote13.git"
  scrubbed git init -q --bare "$remote"
  cat >"$dir/.git/hooks/pre-push" <<'EOF'
#!/bin/sh
while read -r local_ref _rest; do echo "prepush-stdin:$local_ref" >&2; done
exit 1
EOF
  printf '#!/bin/sh\necho ran >"%s/pc13"\n' "$TMP" >"$dir/.git/hooks/post-commit"
  printf '#!/bin/sh\necho ran >"%s/pm13"\n' "$TMP" >"$dir/.git/hooks/post-merge"
  chmod +x "$dir/.git/hooks/pre-push" "$dir/.git/hooks/post-commit" "$dir/.git/hooks/post-merge"
  out="$TMP/13.out"
  if scrubbed git -C "$dir" push "$remote" main >"$out" 2>&1; then
    fail "13 repo-local pre-push still blocks" "push succeeded"
  elif grep -q 'prepush-stdin:refs/heads/main' "$out"; then
    pass "13 repo-local pre-push still runs with stdin and blocks"
  else
    fail "13 repo-local pre-push still runs with stdin and blocks" "$(cat "$out")"
  fi
  scrubbed git -C "$dir" commit -q --allow-empty -m "human commit"
  if [ -f "$TMP/pc13" ]; then pass "13 repo-local post-commit still runs"; else fail "13 repo-local post-commit still runs"; fi
  scrubbed git -C "$dir" checkout -q -b side
  scrubbed git -C "$dir" commit -q --allow-empty -m "side"
  scrubbed git -C "$dir" checkout -q main
  scrubbed git -C "$dir" merge -q --no-edit --no-ff side >/dev/null 2>&1
  if [ -f "$TMP/pm13" ]; then pass "13 repo-local post-merge still runs"; else fail "13 repo-local post-merge still runs"; fi
fi

if [ "$failures" -ne 0 ]; then
  printf 'FAILED %s\n' "$failures"
  exit 1
fi
printf 'ALL PASSED\n'
exit 0
