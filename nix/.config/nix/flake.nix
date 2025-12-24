{
  description = "cozmos nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs
  }:
  let
    # Get username - SUDO_USER preserves original user when running with sudo
    username = let
      sudoUser = builtins.getEnv "SUDO_USER";
      user = builtins.getEnv "USER";
    in if sudoUser != "" then sudoUser else user;

    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # All packages - installed system-wide to /run/current-system/sw/bin
      environment.systemPackages = with pkgs; [
        # GUI Apps
        kitty
        vscode

        # System tools
        mkalias
        stow

        # Shell & Terminal
        fish
        starship

        # CLI Tools
        ripgrep
        fd
        gnupg
        bat
        eza
        fzf
        zoxide
        tldr
        btop
        htop
        tree
        jq
        yq
        fastfetch

        # Git & GitHub
        git
        gh
        lazygit
        delta

        # Development Languages & Tools
        rustup
        fnm
        bun
        go

        # Databases
        redis
        postgresql

        # Cloud & DevOps
        kubectl
        docker

        # Editors
        neovim

        # Build Tools
        cmake
        gnumake

        # Other Utilities
        curl
        wget
        tmux
        direnv

        # Nix tools
        nil
        nixpkgs-fmt
      ];

      fonts.packages = [
        pkgs.monaspace
      ];

      # App aliases for Spotlight
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/Applications" ];
        };
      in pkgs.lib.mkForce ''
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      # Necessary for using flakes on this system
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Primary user for system defaults
      system.primaryUser = username;

      # macOS system settings
      system.defaults = {
        dock.autohide = true;
        dock.magnification = false;
        dock.mineffect = "genie";
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake ~/.config/nix#cozmos
    darwinConfigurations."cozmos" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
