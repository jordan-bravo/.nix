{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Neovim dependencies nvim-dep
    # cargo # Rust package manager and build tool
    delve # Debugger for the Go programming language
    dockerfile-language-server-nodejs # A language server for Dockerfiles # nvim-dep
    emmet-ls # Emmet support based on LSP # nvim-dep
    eslint_d # ESLint daemon for increased performance # nvim-dep
    fzf # nvim-dep
    # gcc # GNU Compiler Collection # nvim-dep # nvim-dep
    gnumake # A tool to control the generation of non-source files from sources # nvim-dep
    gopls # Official language server for Go / Golang # nvim-dep
    hadolint # Dockerfile Linter JavaScript API # nvim-dep
    lazygit # Simple terminal UI for git commands # nvim-dep
    lua-language-server # LSP language server for Lua # nvim-dep
    luajit # JIT compiler for Lua 5.1 # nvim-dep
    luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
    luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
    marksman # Language Server for markdown # nvim-dep
    markdownlint-cli # Command line interface for MarkdownLint
    nil # Nix langauge server # nvim-dep
    nixd # Nix langauge server # nvim-dep
    nixfmt-rfc-style # Official formatter for Nix code
    nixpkgs-fmt # Formatter for Nixlang # nvim-dep
    nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine # nvim-dep
    nodePackages.bash-language-server # A language server for Bash
    nodePackages.eslint # An AST-based pattern checker for JavaScript
    nodePackages.prettier # nvim-dep
    python312Packages.debugpy # Implementation of the Debug Adapter Protocol for Python
    pyright # Python static type checker # nvim-dep
    nodePackages.typescript # nvim-dep
    nodePackages.typescript-language-server # nvim-dep
    prettierd # Prettier daemon for faster formatting # nvim-dep
    # python312 # Python 3.12 # nvim-dep
    # rustc # Rust compiler
    rustfmt # Rust formatter # nvim-dep
    ruff # An extremely fast Python linter # nvim-dep
    # ruff-lsp # Ruff LSP for Python # nvim-dep
    rust-analyzer # Modular compiler frontend for the Rust language
    stylua # Lua code formatter # nvim-dep
    tailwindcss-language-server # LSP functionality for Tailwind CSS # nvim-dep
    unzip # An extraction utility for archives compressed in .zip format # nvim-dep
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode # nvim-dep
    yaml-language-server # Language Server for YAML Files
  ];
}
