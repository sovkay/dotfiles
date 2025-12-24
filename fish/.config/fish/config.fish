set -x PATH /usr/local/bin /opt/homebrew/bin $PATH

if status is-interactive
    # NVM setup
    set -gx NVM_DIR "$HOME/.nvm"

    # Create nvm function for Fish
    function nvm
        bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
    end

    # Optional: Load default node version on shell start
    # Comment this out if you want truly lazy loading
    if test -s (brew --prefix nvm)/nvm.sh
        nvm use default --silent
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

# Set up bun
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $BUN_INSTALL/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $PATH $HOME/.node/corepack


# Cache and load brew environment
if test -f ~/.brew_env
    source ~/.brew_env
else
    /opt/homebrew/bin/brew shellenv > ~/.brew_env
    source ~/.brew_env
end

# pnpm
set -gx PNPM_HOME "/Users/sorv/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Init starship
set STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source

# Added by Antigravity
fish_add_path /Users/sorv/.antigravity/antigravity/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sorv/google-cloud-sdk/path.fish.inc' ]; . '/Users/sorv/google-cloud-sdk/path.fish.inc'; end

# sst
fish_add_path /Users/sorv/.sst/bin
