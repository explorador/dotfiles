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

# Chrome Beta headless with remote debugging for Playwright/Puppeteer CDP
# Connect: chromium.connectOverCDP('http://[::1]:9222')
alias chrome-debug='/Applications/Google\ Chrome\ Beta.app/Contents/MacOS/Google\ Chrome\ Beta --headless=new --remote-debugging-port=9222 --user-data-dir="$HOME/.chrome-debug-profile" --no-first-run --no-default-browser-check'

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
