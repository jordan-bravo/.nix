# ~/.nix/shared/ssh.nix
{
  programs.ssh = {
    enable = true;
    extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
    matchBlocks = {
# This section can be activated to use a different ssh key based on
      # the alias of the repo.  For example, you could set a repo
      # remote to git@bd:org-name/repo-name
      # "bd" = {
      #   hostname = "github.com";
      #   user = "git";
      #   identityFile = "~/.ssh/ssh_id_ed25519_j.b@bd.key";
      #   extraOptions = {
      #     # "UseKeychain" = "no";
      #     # "AddKeysToAgent" = "yes"; # MacOS
      #   };
      # };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh_id_ed25519_j@b.key";
        extraOptions = {
          # "UseKeychain" = "no";
          # "AddKeysToAgent" = "yes"; # MacOS
        };
      };
      "sovserv" = {
        hostname = "sovserv";
        user = "main";
        identityFile = "~/.ssh/ssh_id_ed25519_j@b.key";
      };
      "medserv" = {
        hostname = "sovserv";
        user = "main";
        identityFile = "~/.ssh/ssh_id_ed25519_j@b.key";
      };
      "finserv" = {
        hostname = "sovserv";
        user = "main";
        identityFile = "~/.ssh/ssh_id_ed25519_j@b.key";
      };
    };
  };
}

