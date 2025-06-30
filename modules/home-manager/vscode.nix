{ pkgs }:
{
  programs.vscode = {
    enable = false;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      yzane.markdown-pdf
      # charliermarsh.ruff
      # ms-python.python
      # ];
      # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #   {
      #     name = "roc-lang-unofficial";
      #     publisher = "ivandemchenko";
      #     version = "1.2.0";
      #     sha256 = "sha256-lMN6GlUM20ptg1c6fNp8jwSzlCzE1U0ugRyhRLYGPGE=";
      #   }
    ];
    userSettings = {
      "editor.fontFamily" = "Fira Code";
      "editor.lineNumbers" = "relative";
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "keyboard.dispatch" = "keyCode";
      "vscode-neovim.neovimClean" = true;
      "window.menuBarVisibility" = "toggle";
      "workbench.startupEditor" = "none";
    };
  };
}
