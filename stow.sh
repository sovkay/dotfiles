#!/bin/bash

# Stow all dotfiles packages

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Stowing dotfiles...${NC}"
cd ~/dotfiles

# Ensure ~/.config exists
mkdir -p ~/.config

# List of packages to stow
PACKAGES=("nix" "fish" "nvim" "starship" "ghostty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo -e "${BLUE}  Stowing $package...${NC}"
        stow -R "$package" 2>/dev/null || echo -e "${BLUE}  (conflicts for $package, continuing...)${NC}"
    fi
done

echo -e "${GREEN}Stow complete!${NC}"
