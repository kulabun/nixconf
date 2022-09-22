{ config, pkgs, lib, ... }:
let cheatsPath = "navi/cheats";
in {
  xdg.dataFile."navi/cheats/personal" = {
    source = ./cheats;
    recursive = true;
  };
  programs.navi = {
    enable = true;
    settings = { cheats = { }; };
  };
}
