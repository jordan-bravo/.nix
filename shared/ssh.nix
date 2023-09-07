# ~/.nix/shared/ssh.nix
{
  programs.ssh = {
    enable = true;
    extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
    matchBlocks = {
      "bd" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh_id_ed25519_j.b@bd.key";
        extraOptions = {
          # "UseKeychain" = "no";
          # "AddKeysToAgent" = "yes";
        };
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh_id_ed25519_j@b.key";
        extraOptions = {
          # "UseKeychain" = "no";
          # "AddKeysToAgent" = "yes";
        };
      };
    };
  };
}

