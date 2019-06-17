#!/usr/bin/env bash

echo "###############################################################################"
echo "# Start Bootstrapping..."
echo "###############################################################################"

echo ""
# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install core utils
brew install coreutils

# Tap of dive
brew tap wagoodman/dive

# Install essential packages
PACKAGES=(
    bash
    dive
    fd
    fzf
    git
    goaccess
    htop
    httpie
    jq
    nvm
    ripgrep
    tldr
    tree
    vim
    wget
    zsh
    zsh-autosuggestions
)
echo ""
echo "Installing packages..."
brew install ${PACKAGES[@]}
echo "Cleaning up..."
brew cleanup

# Install essential casks
echo ""
echo "Installing cask..."
brew install caskroom/cask/brew-cask
CASKS=(
    docker-toolbox
    drawio
    google-chrome
    iterm2
    ngrok
    postman
    slack
    visual-studio-code
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

# Install fonts
echo "###############################################################################"
echo "# Configuring OSX..."
echo "###############################################################################"

echo ""
echo "Enabling tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1

echo ""
echo "Show POSIX path in finder title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Creating WORKSPACE folder structure..."
[[ ! -d workspace ]] && mkdir workspace
echo "Bootstrapping complete"