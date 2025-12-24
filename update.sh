#!/bin/bash

set -e

echo "Updating system..."

# =============================================================================
# CONFIGURATION - Edit these values as needed
# =============================================================================
DEFAULT_NODE_VERSION="22"
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update nix-darwin
if [ -d "$HOME/.config/nix" ] && command -v darwin-rebuild &> /dev/null; then
    echo -e "${BLUE}Updating Nix packages...${NC}"
    sudo darwin-rebuild switch --flake ~/.config/nix#cozmos
fi

# Update dotfiles
echo -e "${BLUE}Updating dotfiles...${NC}"
cd ~/dotfiles
git pull 2>/dev/null || true

# Restow (in case structure changed)
PACKAGES=("nix" "fish" "nvim" "starship" "ghostty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        stow -R "$package" 2>/dev/null || true
    fi
done

# Update Node.js via NVM
echo -e "${BLUE}Checking Node.js version...${NC}"
export NVM_DIR="$HOME/.nvm"

# Source nvm
if [ -s "$HOME/.nix-profile/share/nvm/nvm.sh" ]; then
    . "$HOME/.nix-profile/share/nvm/nvm.sh"
elif [ -s "/run/current-system/sw/share/nvm/nvm.sh" ]; then
    . "/run/current-system/sw/share/nvm/nvm.sh"
fi

if command -v nvm &> /dev/null; then
    # Install latest of the default major version
    nvm install "$DEFAULT_NODE_VERSION"
    nvm alias default "$DEFAULT_NODE_VERSION"
    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} is set as default${NC}"
fi

echo -e "${GREEN}Update complete!${NC}"
