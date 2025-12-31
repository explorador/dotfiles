# ===========================================
# Aliases
# ===========================================

# Shell
alias zreload='exec zsh'
alias please='sudo !!'

# Dev tools
alias lg="lazygit"
alias nv="nvim"
alias v="nvim ."
alias web="cd ~/Web"

# tmux
alias ta="tmux attach -t"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"
alias tka="tmux kill-server"

# npm
alias npmplease='rm -rf node_modules/ && rm -f package-lock.json && npm install'

# Homebrew
alias brewery='brew update && brew upgrade && brew cleanup'

# ls
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias lh='ls -Shl'

# Utilities
alias cat='bat'
alias stat='stat -x'
