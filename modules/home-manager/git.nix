{
  programs.git = {
    enable = true;
    aliases = {
      # Deletes branches that have been mergd into master/main, qa, or dev
      tidy = "!git branch --merged | grep -vE \"master|main|qa|staging|development|dev|\\*\" | xargs -n 1 git branch -d";
      br = "!git for-each-ref refs/heads --color=always --sort -committerdate --format='%(HEAD)%(color:reset);%(color:yellow)%(refname:short)%(color:reset);%(contents:subject);%(color:green)(%(committerdate:relative))%(color:blue);<%(authorname)>' | column -t -s ';'";
    };
    delta = {
      enable = true;
      options = {
        syntax-theme = "Visual Studio Dark+";
        navigate = true;
        light = false;
        side-by-side = true;
        plus-style = "syntax \"#003500\"";
        plus-emph-style = "syntax bold \"#007e5e\"";
        minus-style = "syntax \"#5e0000\"";
        minus-emph-style = "syntax bold \"#80002a\"";
      };
    };
    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore-global";
      };
      diff = {
        tool = "nvimdiff";
        colorMoved = "default";
      };
      init.defaultBranch = "master";
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
    # userName = <workstations-secrets>;
    # userEmail = <workstations-secrets>;
    # signing.key = <workstations-secrets>;
    # signing.signByDefault = <workstations-secrets>;

    # This section can be activated to use a differnt GPG key for signing commits
    # based on which directory you're in.
    # includes = [
    #   {
    #     condition = "gitdir:~/bd/";
    #     path = "~/bd/.misc/.gitconfig-bd";
    #   }
    # ];
    # signing = {
    #   signByDefault = true;
    # };
  };
}
