#!/bin/zsh
# Unified workmux interface - open existing or create new worktrees
# Used by tmux keybinding

# ANSI colors
GREEN='\033[32m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

# Normalize branch name to match worktree directory format (slashes and underscores -> dashes)
normalize_name() {
  echo "${1//[_\/]/-}"
}

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

# Main loop with retry support
while true; do
  # Fetch latest from remote first
  git fetch origin --prune 2>/dev/null

  # Get existing worktrees - extract branch name (first column)
  # Skip header line and (here) entry
  existing=$(workmux list 2>/dev/null | tail -n +2 | grep -v '(here)' | \
    awk '{print $1}')

  # Track seen normalized names to avoid duplicates
  typeset -A seen_branches

  # Mark existing worktrees as seen (normalize for matching with PR branches)
  if [[ -n "$existing" ]]; then
    while read -r wt; do
      seen_branches[$(normalize_name "$wt")]=1
    done <<< "$existing"
  fi

  # Get branches with open PRs only, sorted by most recent
  pr_branches=$(gh pr list --state open --json headRefName,updatedAt \
    --jq 'sort_by(.updatedAt) | reverse | .[].headRefName' 2>/dev/null)

  # Deduplicate branches by normalizing slashes to dashes
  filtered_branches=""
  if [[ -n "$pr_branches" ]]; then
    while read -r br; do
      [[ -z "$br" ]] && continue
      normalized=$(normalize_name "$br")

      # Skip if we've already seen this normalized name
      if [[ -z "${seen_branches[$normalized]}" ]]; then
        seen_branches[$normalized]=1
        filtered_branches+="$br"$'\n'
      fi
    done <<< "$pr_branches"
  fi

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
    if [[ -n "$filtered_branches" ]]; then
      echo "$filtered_branches" | while read -r br; do
        [[ -n "$br" ]] && echo "${GREEN}[new]${RESET} $br"
      done
    fi
  ) | fzf --ansi --no-sort --print-query \
         --prompt="Worktree: " \
         --header="[open]=switch, [remove]=delete, [new]=create (open PRs only)" | \
      tail -1)

  # Strip ANSI codes from selection
  selection=$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')

  if [[ -z "$selection" ]]; then
    exit 0
  fi

  if [[ "$selection" == "[open] "* ]]; then
    # Open existing worktree
    name="${selection#\[open\] }"
    workmux open "$(normalize_name "$name")"
    break
  elif [[ "$selection" == "[remove] "* ]]; then
    # Remove worktree (with confirmation)
    name="${selection#\[remove\] }"
    echo "Remove worktree '$name'? (y/N) "
    if read -q; then
      echo
      if workmux remove "$(normalize_name "$name")"; then
        break
      else
        echo "\nFailed to remove worktree. Press any key to retry..."
        read -k1
        continue
      fi
    fi
    break
  elif [[ "$selection" == "[new] "* ]]; then
    # Create new worktree from branch
    branch="${selection#\[new\] }"
    ref=$(get_branch_ref "$branch")
    if workmux add "$ref"; then
      break
    else
      echo "\nFailed to create worktree. Press any key to retry..."
      read -k1
      continue
    fi
  else
    # User typed a custom branch name
    ref=$(get_branch_ref "$selection")
    if workmux add "$ref"; then
      break
    else
      echo "\nFailed to create worktree. Press any key to retry..."
      read -k1
      continue
    fi
  fi
done
