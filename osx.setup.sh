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

# Install Bash 4
brew install bash

# Install essential packages
PACKAGES=(
    fzf
    git
    nvm
    tree
    ripgrep
    vim
    wget
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
    google-chrome
    slack
    sublime
    vargant
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
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Creating WORKSPACE folder structure..."
[[ ! -d workspace ]] && mkdir workspace
echo "Bootstrapping complete"