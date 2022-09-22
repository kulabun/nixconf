{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ pinentry-curses ];
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  programs.gpg.enable = true;
}
