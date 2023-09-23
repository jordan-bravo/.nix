# ~/.nix/shared/git.nix
{
  programs.git = {
    aliases = {
      # Deletes branches that have been mergd into main, qa, or dev
      tidy = "!git branch --merged | grep -vE \"main|qa|dev|\\*\" | xargs -n 1 git branch -d";
      br = "!git for-each-ref refs/heads --color=always --sort -committerdate --format='%(HEAD)%(color:reset);%(color:yellow)%(refname:short)%(color:reset);%(contents:subject);%(color:green)(%(committerdate:relative))%(color:blue);<%(authorname)>' | column -t -s ';'";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
    enable = true;
    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore-global";
      };
      diff = {
        tool = "nvimdiff";
        colorMoved = "default";
      };
      merge = {
        conflictstyle = "diff3";
      };
      mergetool.nvimdiff = {
        layout = "(LOCAL,REMOTE)/MERGED";
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
    };
    includes = [
      {
        path = "~/bd/.gitconfig-bd";
        condition = "gitdir:~/bd/";
      }
    ];
    userName = "Jordan Bravo";
    userEmail = "jordan@bravo.cc";
    signing = {
      key = "E11FA432F965854B";
      signByDefault = true;
    };
  };
}
