{ config, pkgs, lib, ... }: {
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      Include config.local
    '';
  };
}
