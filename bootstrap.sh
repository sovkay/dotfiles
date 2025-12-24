#!/bin/bash

set -e  # Exit on error

echo "Starting bootstrap..."

# =============================================================================
# CONFIGURATION - Edit these values as needed
# =============================================================================
DEFAULT_NODE_VERSION="22"
# =============================================================================

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${BLUE}Installing Nix...${NC}"
    sh <(curl -L https://nixos.org/nix/install)

    # Source nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo -e "${GREEN}Nix already installed${NC}"
fi

# Stow nix config first (needed before darwin-rebuild)
echo -e "${BLUE}Stowing nix config...${NC}"
cd ~/dotfiles
mkdir -p ~/.config
stow -R nix 2>/dev/null || echo -e "${BLUE}  (stow reports conflicts for nix, continuing...)${NC}"

# Check if nix-darwin is installed
if ! command -v darwin-rebuild &> /dev/null; then
    echo -e "${BLUE}Installing nix-darwin...${NC}"
    nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix#cozmos
else
    echo -e "${GREEN}nix-darwin already installed${NC}"
    # Apply nix-darwin configuration
    echo -e "${BLUE}Applying nix-darwin configuration...${NC}"
    darwin-rebuild switch --flake ~/.config/nix#cozmos
fi

# Stow remaining dotfiles
echo -e "${BLUE}Stowing dotfiles...${NC}"
cd ~/dotfiles

# List of packages to stow
PACKAGES=("fish" "nvim" "starship" "ghostty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo -e "${BLUE}  Stowing $package...${NC}"
        stow -R "$package" 2>/dev/null || echo -e "${BLUE}  (stow reports conflicts for $package, continuing...)${NC}"
    fi
done

# Setup NVM and install default Node version
echo -e "${BLUE}Setting up NVM...${NC}"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

# Source nvm (installed via nix)
if [ -s "$HOME/.nix-profile/share/nvm/nvm.sh" ]; then
    . "$HOME/.nix-profile/share/nvm/nvm.sh"
elif [ -s "/run/current-system/sw/share/nvm/nvm.sh" ]; then
    . "/run/current-system/sw/share/nvm/nvm.sh"
fi

# Install and set default Node version
if command -v nvm &> /dev/null; then
    echo -e "${BLUE}Installing Node.js v${DEFAULT_NODE_VERSION}...${NC}"
    nvm install "$DEFAULT_NODE_VERSION"
    nvm alias default "$DEFAULT_NODE_VERSION"
    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} installed and set as default${NC}"
else
    echo -e "${BLUE}NVM not found in path, skipping Node setup...${NC}"
fi

# Set fish as default shell if not already
FISH_PATH=$(which fish 2>/dev/null || echo "/run/current-system/sw/bin/fish")
if [ -x "$FISH_PATH" ] && [ "$SHELL" != "$FISH_PATH" ]; then
    echo -e "${BLUE}Setting fish as default shell...${NC}"
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    chfs -s "$FISH_PATH"
    echo -e "${GREEN}Fish set as default shell${NC}"
else
    echo -e "${GREEN}Fish already default shell${NC}"
fi

echo ""
echo -e "${GREEN}Bootstrap complete!${NC}"
echo ""
echo "Please restart your terminal or run:"
echo "  exec fish"
echo ""
