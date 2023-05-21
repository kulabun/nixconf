{ config, lib, inputs, user, stateVersion, ... }:
with lib;
let cfg = config.system'.home-manager;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.system'.home-manager = {
    enable = mkEnableOption "home-manager" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs user; };

      users.${user} = {
        home = {
          inherit stateVersion;
          username = "${user}";
          homeDirectory = "/home/${user}";
        };

        programs = { home-manager.enable = true; };

        manual = {
          html.enable = true;
          json.enable = true;
        };
      };
    };
  };
}
