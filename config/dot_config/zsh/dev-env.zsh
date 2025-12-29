# ===========================================
# Dev Environment Functions
# ===========================================

# ===========================================
# ZOXIDE (smart cd)
# ===========================================
eval "$(zoxide init zsh)"

# ===========================================
# FZF
# ===========================================
source <(fzf --zsh)

# FZF Theme (Ayu Mirage)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#232834,bg:#1f2430,spinner:#ffcc66,hl:#f28779 \
--color=fg:#cbccc6,header:#f28779,info:#d4bfff,pointer:#ffcc66 \
--color=marker:#ffcc66,fg+:#cbccc6,prompt:#d4bfff,hl+:#f28779 \
--color=border:#707a8c"

# Use fd for faster file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ===========================================
# PROJECT LAUNCHER (proj command)
# ===========================================
PROJECT_DIRS=(
    "$HOME/Web"
    "$HOME/.dotfiles"
)

proj() {
    local project

    # Find all git repositories in PROJECT_DIRS
    project=$(for dir in "${PROJECT_DIRS[@]}"; do
        fd --type d --hidden '^\.git$' "$dir" --print0 2>/dev/null | xargs -0 -n1 dirname
    done | sed "s|$HOME/||" | sort | \
        fzf --height 40% --reverse --border --prompt="  Project: " --header="Select a project")

    [[ -z "$project" ]] && return

    local full_path="$HOME/$project"
    local session_name=$(basename "$project" | tr '.' '_')

    # Check if we're already in tmux
    if [[ -n "$TMUX" ]]; then
        # Already in tmux - just cd and open nvim
        cd "$full_path" && nvim .
    else
        # Check if session exists
        if tmux has-session -t "$session_name" 2>/dev/null; then
            # Attach to existing session
            tmux attach -t "$session_name"
        else
            # Create new session with nvim + terminal layout
            tmux new-session -d -s "$session_name" -c "$full_path"
            tmux send-keys -t "$session_name" "nvim ." Enter
            tmux split-window -h -t "$session_name" -c "$full_path"
            tmux select-pane -t "$session_name:0.0"
            tmux attach -t "$session_name"
        fi
    fi
}

# ===========================================
# ALIASES
# ===========================================
alias lg="lazygit"
alias nv="nvim"
alias v="nvim ."
alias web="cd ~/Web"

# tmux aliases
alias ta="tmux attach -t"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"
alias tka="tmux kill-server"
