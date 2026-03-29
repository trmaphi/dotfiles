#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "###############################################################################"
echo "# Start Bootstrapping..."
echo "###############################################################################"

# 1. Install Homebrew (Modern method)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Set path for the current session based on architecture
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# 2. Use Brewfile for all installations
# This replaces your PACKAGES and CASKS arrays
echo "Updating Homebrew and installing bundles..."
brew update
brew upgrade

# Create a temporary Brewfile or point to one in your dotfiles
# Using a 'here document' to keep this script self-contained
brew bundle --no-lock --file=- <<EOF
# Taps
tap "homebrew/bundle"
tap "wagoodman/dive"

# Executables
brew "coreutils"
brew "mise"
brew "bat"
brew "bash"
brew "bash-completion@2"
brew "dive"
brew "findutils"
brew "fzf"
brew "git"
brew "gnu-sed"
brew "grep"
brew "htop"
brew "httpie"
brew "jq"
brew "nvm"
brew "stow"
brew "tldr"
brew "tmux"
brew "tree"
brew "vim"
brew "wget"
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "osv-scanner"
brew "gitleaks"

# Casks (GUI Apps)
cask "copyq"
cask "claude-code"
cask "google-chrome"
cask "cloudflared"
cask "visual-studio-code"
EOF

echo "Cleaning up Homebrew..."
brew cleanup

echo "###############################################################################"
echo "# Configuring macOS..."
echo "###############################################################################"

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Screenshots
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# Finder: show path bar and full POSIX path in title
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Workspace
mkdir -p ~/sources

# VS Code Symlink (Safe version)
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
DOTFILES_VSCODE="$HOME/dotfiles/vscode/User"

if [ -d "$DOTFILES_VSCODE" ]; then
    echo "Linking VS Code Settings..."
    rm -rf "$VSCODE_USER_DIR"
    ln -s "$DOTFILES_VSCODE" "$VSCODE_USER_DIR"
else
    echo "Warning: $DOTFILES_VSCODE not found. Skipping VS Code link."
fi

# Private config
touch ~/private.config.sh

echo "Bootstrapping complete! Please restart your shell or reboot for all changes to take effect."
