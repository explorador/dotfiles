# Brewfile - Homebrew Bundle
# Install: brew bundle --file=~/.dotfiles/Brewfile
# Sync:    brewsync --pull

# Tap repositories
tap "arl/arl"
tap "shopify/shopify"

# CLI tools
brew "archey4"
brew "bat"
brew "chafa"
brew "chezmoi"
brew "fd"
brew "ffmpeg"
brew "ffmpegthumbnailer"
brew "figlet"
brew "fzf"
brew "gh"
brew "gitmux"
brew "imagemagick"
brew "jq"
brew "lazygit"
brew "libsixel"
brew "luarocks"
brew "mas"
brew "mkcert"
brew "neovim"
brew "nmap"
brew "poppler"
brew "ripgrep"
brew "shopify-cli"
brew "tldr"
brew "tmux"
brew "um"
brew "unar"
brew "yazi"
brew "yt-dlp"
brew "zoxide"

# Fonts
cask "font-droid-sans-mono-nerd-font"

# Terminal emulators
cask "iterm2"
cask "kitty"

# Productivity
cask "1password"
cask "1password-cli"
cask "alfred"
cask "keyclu"
cask "jumpshare"
cask "muzzle"
cask "notion"
cask "numi"
cask "raindropio"
cask "rectangle"

# Browsers
cask "firefox@developer-edition"
cask "google-chrome"
cask "safari-technology-preview"
# Communication
cask "slack"

# Media
cask "fliqlo"
cask "vlc"

# Development
cask "dash"
cask "docker-desktop"
cask "gas-mask"
cask "iconjar"
cask "poedit"
cask "postman"
cask "table-tool"

# Virtualization
cask "virtualbox"

# Utilities
cask "the-unarchiver"
cask "tinypng4mac"

# ===========================================
# Personal only (skipped on work machines)
# ===========================================
unless ENV["HOMEBREW_MACHINE"] == "work"
  cask "daisydisk"
  cask "dropbox"
  cask "ibettercharge"
  cask "omnigraffle"
  cask "spotify"
  cask "transmit"
  cask "whatsapp"

  # Mac App Store apps (requires: brew install mas)
  mas "Bible", id: 917664748
  mas "HTML Email Signature - Outlook", id: 1101267774
  mas "SnippetsLab", id: 1006087419
  mas "Speedtest", id: 1153157709
  mas "Xcode", id: 497799835
end
