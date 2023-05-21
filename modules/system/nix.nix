{ config, lib, stateVersion, user, pkgs, ... }:
with lib;
let cfg = config.system'.nix;
in {
  options.system'.nix = {
    enable = mkEnableOption "nix config" // { default = true; };
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 1d";
      };
      settings = {
        allowed-users = [ "@wheel" ];
        trusted-users = [ "root" "@wheel" ];
        auto-optimise-store = true;
        system-features = [ "big-parallel" ];
        keep-outputs = true;
        keep-derivations = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    system = {
      inherit stateVersion;
      autoUpgrade = {
        enable = false;
        channel = "https://nixos.org/channels/nixos-${stateVersion}";
      };
    };

    environment.systemPackages = with pkgs; [
      nix-prefetch-scripts
      nix-index
      nix-info
      nix-ld
    ];
  };
}
