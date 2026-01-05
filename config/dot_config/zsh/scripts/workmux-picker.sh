#!/bin/zsh
# Unified workmux interface - open existing or create new worktrees
# Used by tmux keybinding

# ANSI colors
GREEN='\033[32m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

# Fetch latest from remote first
git fetch origin --prune 2>/dev/null

# Get existing worktrees - extract directory name from PATH column
# Skip header line and (here) entry, get the basename of the path
existing=$(workmux list 2>/dev/null | tail -n +2 | grep -v '(here)' | \
  awk '{print $NF}' | xargs -I{} basename {})

# Get all branches sorted by most recent commit, deduplicated
branches=$(git branch -a --sort=-committerdate --format='%(refname:short)' 2>/dev/null | \
  sed 's|^origin/||' | awk '!/^HEAD$/ && !seen[$0]++')

# Build fzf input: existing worktrees first, then branches for new
selection=$( (
  if [[ -n "$existing" ]]; then
    echo "$existing" | while read -r wt; do
      echo "${CYAN}[open]${RESET} $wt"
    done
    echo "$existing" | while read -r wt; do
      echo "${RED}[remove]${RESET} $wt"
    done
  fi
  echo "$branches" | while read -r br; do
    echo "${GREEN}[new]${RESET} $br"
  done
) | fzf --ansi --no-sort --print-query \
       --prompt="Worktree: " \
       --header="[open]=switch, [remove]=delete, [new]=create" | \
    tail -1)

# Strip ANSI codes from selection
selection=$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')

if [[ -z "$selection" ]]; then
  exit 0
fi

get_branch_ref() {
  local branch="$1"
  # If branch exists on remote, use origin/ prefix to ensure latest remote version
  # Also delete stale local branch if it exists and isn't in a worktree
  if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # Delete stale local branch if not checked out in any worktree
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      git branch -D "$branch" 2>/dev/null
    fi
    echo "origin/$branch"
  else
    echo "$branch"
  fi
}

if [[ "$selection" == "[open] "* ]]; then
  # Open existing worktree
  name="${selection#\[open\] }"
  workmux open "$name"
elif [[ "$selection" == "[remove] "* ]]; then
  # Remove worktree (with confirmation)
  name="${selection#\[remove\] }"
  echo "Remove worktree '$name'? (y/N) "
  read -q && workmux remove "$name"
elif [[ "$selection" == "[new] "* ]]; then
  # Create new worktree from branch
  branch="${selection#\[new\] }"
  ref=$(get_branch_ref "$branch")
  workmux add "$ref"
else
  # User typed a custom branch name
  ref=$(get_branch_ref "$selection")
  workmux add "$ref"
fi
