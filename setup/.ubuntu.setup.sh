#!/usr/bin/env bash

set -e

echo "###############################################################################"
echo "# Ubuntu Native Bootstrapping (No Homebrew)"
echo "###############################################################################"

# 1. Update and install system essentials
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    build-essential \
    curl \
    git \
    stow \
    jq \
    htop \
    httpie \
    bat \
    fzf \
    tmux \
    vim \
    wget \
    zsh \
    gitleaks \
    ca-certificates \
    gnupg \
    lsb-release

# 2. Fix 'bat' command name (Ubuntu installs it as 'batcat')
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat

# 3. Install mise (Replacement for brew for dev tools)
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.jrx.nl/install.sh | sh
fi

# 4. Desktop-Specific (Skip if WSL)
if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    echo "---> Ubuntu Desktop detected. Installing GUI apps..."
    sudo snap install code --classic
    sudo snap install google-chrome
    
    # GNOME Settings
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    mkdir -p ~/Pictures/Screenshots
    gsettings set org.gnome.gnome-screenshot auto-save-directory "file://$HOME/Pictures/Screenshots"
fi

# 5. VS Code Symlinks (Linux Path)
VSCODE_USER_DIR="$HOME/.config/Code/User"
DOTFILES_VSCODE="$HOME/dotfiles/vscode/User"

if [ -d "$DOTFILES_VSCODE" ]; then
    echo "Linking VS Code Settings..."
    mkdir -p "$VSCODE_USER_DIR"
    # Link settings.json and keybindings.json individually to avoid nuking the folder
    ln -sf "$DOTFILES_VSCODE/settings.json" "$VSCODE_USER_DIR/settings.json"
    ln -sf "$DOTFILES_VSCODE/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
fi

echo "Done! Please restart your shell."