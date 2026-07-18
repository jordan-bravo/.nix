# Shared interactive zsh init, sourced by:
#   - modules/nixos/nixos-all.nix (programs.zsh.interactiveShellInit — /etc/zshrc, incl. root)
#   - modules/home-manager/zsh.nix (programs.zsh.initContent — user .zshrc)
# It must run from home-manager too: HM's `bindkey -v` (defaultKeymap = viins)
# runs after /etc/zshrc and would otherwise discard the ^U binding below.

# If bat exists, use instead of cat
type bat > /dev/null 2>&1 && alias cat=bat

# If lsd exists, use instead of ls
type lsd > /dev/null 2>&1 && alias ls=lsd

# If zoxide exists, use instead of cd
type zoxide > /dev/null 2>&1 && alias cd=z

# If ripgrep exists, use instead of grep
type rg > /dev/null 2>&1 && alias grep=rg

# If fd exists, use instead of find
type fd > /dev/null 2>&1 && alias find=fd

# If duf exists, use instead of df
type duf > /dev/null 2>&1 && alias df=duf

# If dust exists, use instead of du
type dust > /dev/null 2>&1 && alias du=dust

# Accept next word from zsh autosuggestion with Ctrl+U
bindkey ^U forward-word

# Disable git pull
git() { if [[ $@ == "pull" ]]; then command echo "git pull disabled.  Use git fetch + git merge."; else command git "$@"; fi; }
