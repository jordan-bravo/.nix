# ~/.nix/shared/ripgrep.nix

{
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Don't let ripgrep vomit really long lines to the terminal, and show a preview.
      # "--max-columns=150"
      "--max-columns-preview"

      # Search hidden files / directories (e.g. dotfiles) by default
      "--hidden"

      # Ignore node_modules anywhere
      "--glob=!**/node_modules/**"

      # Ignore package-lock.json
      # "--glob=!package-lock.json"

      # Using glob patterns to include/exclude files or folders
      "--glob=!.git/*"
      "--glob=!.venv/*"
      "--glob=!.venv3/*"
      "--glob=!.cache/*"
      "--glob=!.mozilla/*"
      "--glob=!.infisical/*"
      "--glob=!.gnupg/*"
      "--glob=!.nix-defexpr/*"
      "--glob=!.node_repl_history"
      "--glob=!.npm/*"
      "--glob=!.pki/*"
      "--glob=!.thunderbird/*"
      "--glob=!.var/*"
      "--glob=!.config/BraveSoftware/Brave-Browser/Default/Extensions/*"
      "--glob=!.local/share/zsh/*"

      # Ignore case when patter is all lowercase
      "--smart-case"

      # Don't respect ignore files (.gitignore, .ignore, etc.)
      "--no-ignore"
    ];
  };
}
