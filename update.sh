#!/bin/bash

set -e

echo "Updating system..."

# =============================================================================
# CONFIGURATION - Edit these values as needed
# =============================================================================
DEFAULT_NODE_VERSION="22"
DARWIN_CONFIG_NAME="cozmos"  # Must match darwinConfigurations in flake.nix
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update dotfiles first
echo -e "${BLUE}Updating dotfiles...${NC}"
cd ~/dotfiles
git pull 2>/dev/null || true

# Restow (in case structure changed)
PACKAGES=("nix" "fish" "nvim" "starship" "kitty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        stow -R "$package" 2>/dev/null || true
    fi
done

# Update nix-darwin
if command -v darwin-rebuild &> /dev/null; then
    echo -e "${BLUE}Updating Nix packages for ${DARWIN_CONFIG_NAME}...${NC}"

    # Apply configuration
    sudo -H darwin-rebuild switch --flake ~/.config/nix#${DARWIN_CONFIG_NAME}
fi

# Update Node.js via fnm
echo -e "${BLUE}Checking Node.js version...${NC}"
if command -v fnm &> /dev/null; then
    eval "$(fnm env)"
    fnm install "$DEFAULT_NODE_VERSION"
    fnm default "$DEFAULT_NODE_VERSION"
    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} is set as default${NC}"
else
    echo -e "${BLUE}fnm not found, skipping Node.js update...${NC}"
fi

# Set fish as default shell if not already
FISH_PATH=$(which fish 2>/dev/null || echo "/run/current-system/sw/bin/fish")
if [ -x "$FISH_PATH" ] && [ "$SHELL" != "$FISH_PATH" ]; then
    echo -e "${BLUE}Setting fish as default shell...${NC}"
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$FISH_PATH"
    echo -e "${GREEN}Fish set as default shell${NC}"
else
    echo -e "${GREEN}Fish already default shell${NC}"
fi


echo -e "${GREEN}Update complete!${NC}"
