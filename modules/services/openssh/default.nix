{ config, lib, user, ... }:
with lib;
let
  cfg = config.services'.openssh;
  authorizedKeysFiles = map (name: ./authorized_keys/${name}) (attrNames (builtins.readDir ./authorized_keys));
in
{
  options.services'.openssh.enable = mkEnableOption "openssh";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keyFiles = authorizedKeysFiles;
      root.openssh.authorizedKeys.keyFiles = authorizedKeysFiles;
    };

    programs.ssh.startAgent = true;
  };
}
