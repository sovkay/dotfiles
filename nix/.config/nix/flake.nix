{
  description = "cozmos nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager
  }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # System packages (GUI apps and tools that need system-level install)
      environment.systemPackages = [
        pkgs.ghostty-bin
        pkgs.mkalias
        pkgs.stow
        pkgs.vscode
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
      system.primaryUser = "sav";

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

    homeconfig = { pkgs, ... }: {
      home.username = "sav";
      home.homeDirectory = "/Users/sav";
      home.stateVersion = "24.11";

      # All packages managed by home-manager
      home.packages = with pkgs; [
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
        nvm               # Node version manager
        bun               # Fast JS runtime & package manager
        go

        # Databases
        redis
        postgresql
        beekeeper-studio

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

      # VSCode with extensions
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
      };

      # Programs: only enable those that don't conflict with stowed dotfiles
      # fish, git, neovim, starship configs are managed via stow - don't enable here
      programs.fzf.enable = true;
      programs.zoxide.enable = true;
      programs.direnv.enable = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake ~/.config/nix#cozmos
    darwinConfigurations."cozmos" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sav = homeconfig;
        }
      ];
    };
  };
}
