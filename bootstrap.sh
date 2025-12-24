#!/bin/bash

set -e  # Exit on error

echo "Starting bootstrap..."

# =============================================================================
# CONFIGURATION - Edit these values as needed
# =============================================================================
DEFAULT_NODE_VERSION="22"
DARWIN_CONFIG_NAME="cozmos"  # Must match darwinConfigurations in flake.nix
# =============================================================================

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${BLUE}Installing Nix (multi-user daemon mode)...${NC}"
    curl -L https://nixos.org/nix/install | sh

    echo ""
    echo -e "${GREEN}Nix installed!${NC}"
    echo -e "${BLUE}Please restart your terminal and run this script again.${NC}"
    exit 0
fi

echo -e "${GREEN}Nix already installed${NC}"

# Ensure nix-daemon is sourced in current shell
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Stow nix config (the flake) to ~/.config/nix
echo -e "${BLUE}Stowing nix flake config...${NC}"
cd ~/dotfiles
mkdir -p ~/.config
nix-shell -p stow --run "stow -R nix" 2>/dev/null || echo -e "${BLUE}  (stow reports conflicts for nix, continuing...)${NC}"

# Install/update nix-darwin
if ! command -v darwin-rebuild &> /dev/null; then
    echo -e "${BLUE}Moving bash, zsh and ca files as backups...${NC}"
    sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
    sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
    sudo mv /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt.before-nix-darwin

    echo -e "${BLUE}Installing nix-darwin...${NC}"
    sudo -H nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#${DARWIN_CONFIG_NAME}
else
    echo -e "${GREEN}nix-darwin already installed${NC}"
    echo -e "${BLUE}Applying nix-darwin configuration...${NC}"
    sudo -H darwin-rebuild switch --flake ~/.config/nix#${DARWIN_CONFIG_NAME}
fi

# Stow remaining dotfiles
echo -e "${BLUE}Stowing dotfiles...${NC}"
cd ~/dotfiles

PACKAGES=("fish" "nvim" "starship" "kitty" "zed" "gh" "fastfetch" "omf" "profile")

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo -e "${BLUE}  Stowing $package...${NC}"
        stow -R "$package" 2>/dev/null || echo -e "${BLUE}  (stow reports conflicts for $package, continuing...)${NC}"
    fi
done

# Setup fnm and install default Node version
if command -v fnm &> /dev/null; then
    echo -e "${BLUE}Setting up fnm environment...${NC}"
    eval "$(fnm env)"

    echo -e "${BLUE}Installing Node.js v${DEFAULT_NODE_VERSION}...${NC}"
    fnm install "$DEFAULT_NODE_VERSION"
    fnm default "$DEFAULT_NODE_VERSION"
    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} installed and set as default${NC}"
else
    echo -e "${BLUE}fnm not found in path, skipping Node setup...${NC}"
fi

# Setup rustup (installed via nix, but needs initialization)
if command -v rustup &> /dev/null; then
    if [ ! -d "$HOME/.rustup" ]; then
        echo -e "${BLUE}Initializing rustup...${NC}"
        rustup default stable
        echo -e "${GREEN}Rust stable toolchain installed${NC}"
    else
        echo -e "${GREEN}Rustup already initialized${NC}"
    fi
fi

# Install Oh My Fish if not present
if [ ! -d "$HOME/.local/share/omf" ]; then
    echo -e "${BLUE}Installing Oh My Fish...${NC}"
    curl -sSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish --command 'source - --noninteractive --yes'
    echo -e "${GREEN}Oh My Fish installed${NC}"
else
    echo -e "${GREEN}Oh My Fish already installed${NC}"
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

echo ""
echo -e "${GREEN}Bootstrap complete!${NC}"
echo ""
echo "Please restart your terminal or run:"
echo "  exec fish"
echo ""
