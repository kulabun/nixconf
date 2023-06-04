{ config, lib, user, ... }:
with lib;
let cfg = config.system'.user;
in {
  options.system'.user = {
    enable = mkEnableOption "user config" // { default = true; };
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = true;
      groups.${user}.gid = 1000;

      users.${user} = {
        uid = 1000;
        isNormalUser = true;
        extraGroups = [ "wheel" "video" user ];
        initialPassword = "changeme";
        createHome = true;
        home = "/home/${user}";
      };
    };
    security.sudo.wheelNeedsPassword = false;
  };
}
