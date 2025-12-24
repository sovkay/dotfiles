#!/bin/bash

set -e

echo "Updating system..."

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update nix-darwin
if [ -d "$HOME/.config/nix" ]; then
    echo -e "${BLUE}Updating Nix packages...${NC}"
    cd ~/.config/nix
    git pull 2>/dev/null || true
    darwin-rebuild switch --flake .#cozmos
fi

# Update dotfiles
echo -e "${BLUE}Updating dotfiles...${NC}"
cd ~/dotfiles
git pull 2>/dev/null || true

# Restow (in case structure changed)
PACKAGES=("fish" "nvim" "starship" "ghostty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        stow -R "$package" 2>/dev/null || true
    fi
done

echo -e "${GREEN}Update complete!${NC}"
