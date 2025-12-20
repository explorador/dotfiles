# ===========================================
# Dev Environment Functions
# Save as: ~/.oh-my-zsh/custom/dev-env.zsh
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
PROJECTS_DIR="$HOME/Web"

proj() {
    local project

    # Find all git repositories at any depth
    project=$(fd --type d --hidden '^\.git$' "$PROJECTS_DIR" 2>/dev/null | \
        xargs -n1 dirname | \
        sed "s|$PROJECTS_DIR/||" | \
        sort | \
        fzf --height 40% --reverse --border --prompt="  Project: " --header="Select a project")

    [[ -z "$project" ]] && return

    local full_path="$PROJECTS_DIR/$project"
    local session_name=$(basename "$project" | tr '.' '_')

    # Check if we're already in zellij
    if [[ -n "$ZELLIJ" ]]; then
        # Already in zellij - just cd and open nvim
        cd "$full_path" && nvim .
    else
        # Check if session exists
        if zellij list-sessions 2>/dev/null | grep -q "^$session_name"; then
            # Attach to existing session
            zellij attach "$session_name"
        else
            # Create new session
            cd "$full_path"
            zellij --session "$session_name" --layout default
        fi
    fi
}

# ===========================================
# ALIASES
# ===========================================
alias lg="lazygit"
alias nv="nvim"
alias zj="zellij"
alias zja="zellij attach"
alias zjl="zellij list-sessions"
alias zjd="zellij delete-session"
alias zjk="zellij kill-session"
alias v="nvim ."
alias web="cd ~/Web"
