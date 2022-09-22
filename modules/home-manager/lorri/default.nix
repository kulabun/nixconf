{ config, pkgs, ... }: {
  home = { packages = with pkgs; [ direnv ]; };
  services = { lorri.enable = true; };
}

