# ~/.nix/shared/ripgrep.nix

{
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Limit line-length of ripgrep's output
      # "--max-columns=150"

      # Show a preview
      "--max-columns-preview"

      # Search hidden files / directories (e.g. dotfiles) by default
      "--hidden"

      # Ignore node_modules anywhere
      "--glob=!**/node_modules/**"

      # Ignore package-lock.json
      # "--glob=!package-lock.json"

      # Using glob patterns to include/exclude files or folders
      "--glob=!.cache/*"
      "--glob=!.config/BraveSoftware/Brave-Browser/Default/Extensions/*"
      "--glob=!.direnv/*"
      "--glob=!.git/*"
      "--glob=!.local/share/zsh/*"
      "--glob=!.gnupg/*"
      "--glob=!.infisical/*"
      "--glob=!.mozilla/*"
      "--glob=!.nix-defexpr/*"
      "--glob=!.node_repl_history"
      "--glob=!.npm/*"
      "--glob=!.pki/*"
      "--glob=!.thunderbird/*"
      "--glob=!.var/*"
      "--glob=!.venv/*"

      # Ignore case when patter is all lowercase
      "--smart-case"

      # Don't respect ignore files (.gitignore, .ignore, etc.)
      "--no-ignore"
    ];
  };
}
