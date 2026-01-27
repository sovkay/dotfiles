fish_add_path /opt/homebrew/bin

if status is-interactive
    # fnm (Fast Node Manager) setup
    if command -q fnm
        fnm env --use-on-cd --shell fish | source
    end

    fastfetch -c $HOME/.config/fastfetch/config.jsonc
end

# Set code-insiders alias
alias vsc="code"
alias cr="cursor"
alias w="webstorm"
alias n="nvim"

# Git shortcuts
alias g="git"
alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gb="git branch"
alias gd="git diff"
alias ga="git add"
alias gaa="git add ."
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate"
alias gst="git stash"
alias gstp="git stash pop"
alias gr="git reset"
alias grb="git rebase"
alias gcl="git clone"
alias gcp="git cherry-pick"

# Dotfiles management
alias dots="cd ~/dotfiles"
alias dotsup="~/dotfiles/update.sh"
alias stowit="~/dotfiles/stow.sh"
alias nixup="darwin-rebuild switch --flake ~/.config/nix#cozmos"

# Set up bun
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $BUN_INSTALL/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $PATH $HOME/.node/corepack

# pnpm
set -gx PNPM_HOME "/Users/sorv/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Init starship
set STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set HOMEBREW_NO_ENV_HINTS 1
starship init fish | source


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sorv/google-cloud-sdk/path.fish.inc' ]; . '/Users/sorv/google-cloud-sdk/path.fish.inc'; end

# sst
fish_add_path /Users/sorv/.sst/bin

# Port management functions
function wort
    if test (count $argv) -eq 0
        echo "Usage: wort <port>"
        return 1
    end
    lsof -i :$argv[1]
end

function pill
    if test (count $argv) -eq 0
        echo "Usage: pill <port>"
        return 1
    end
    set -l pids (lsof -i :$argv[1] 2>/dev/null | awk 'NR>1 {print $2}' | sort -u)
    if test (count $pids) -eq 0
        echo "No processes found on port $argv[1]"
        return 1
    end
    for pid in $pids
        kill $pid 2>/dev/null
    end
    echo "Killed processes on port $argv[1]: $pids"
end

