#!/bin/bash

set -e  # Exit on error

echo "Starting bootstrap..."

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

# Check if nix-darwin is installed
if ! command -v darwin-rebuild &> /dev/null; then
    echo -e "${BLUE}Installing nix-darwin...${NC}"
    nix run nix-darwin -- switch --flake ~/.config/nix#cozmos
else
    echo -e "${GREEN}nix-darwin already installed${NC}"
fi

# Apply nix-darwin configuration
if [ -d "$HOME/.config/nix" ]; then
    echo -e "${BLUE}Applying nix-darwin configuration...${NC}"
    darwin-rebuild switch --flake ~/.config/nix#cozmos
else
    echo -e "${BLUE}No nix config found at ~/.config/nix, skipping...${NC}"
fi

# Stow dotfiles
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

echo ""
echo -e "${GREEN}Bootstrap complete!${NC}"
echo ""
echo "Please restart your terminal or run:"
echo "  exec fish"
echo ""
