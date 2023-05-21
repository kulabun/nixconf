{ config, lib, user, ... }:
with lib;
let
  cfg = config.system'.ssh;
  sops = config.system'.sops;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in
{
  options.system'.ssh = {
    enable = mkEnableOption "ssh config" // { default = true; };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.ssh = {
        startAgent = true;
      };

      home-manager.users.${user} = {
        programs.ssh = {
          enable = true;
          forwardAgent = true;
          matchBlocks."*".identitiesOnly = true;
        };
      };
    }

    (mkIf sops.home.enable {
      home-manager.users.${user} = {
        programs.ssh.includes = [
          "${homeDirectory}/.ssh/config.local"
          "${homeDirectory}/.ssh/config.secret"
        ];
      };
    })

    (mkIf sops.system.enable {
      programs.ssh = {
        extraConfig = ''
          Include /etc/ssh/my/ssh_config
        '';
      };
    })
  ]);
}
