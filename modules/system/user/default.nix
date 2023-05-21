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
      users.${user} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "changeme";
        createHome = true;
        home = "/home/${user}";
      };
    };
    security.sudo.wheelNeedsPassword = false;
  };
}
