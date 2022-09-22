{ pkgs, config, lib, ... }:

with lib; {
  options.settings = let
    strOption = description:
      mkOption {
        inherit description;
        type = types.str;
        readOnly = true;
      };
    intOption = description:
      mkOption {
        inherit description;
        type = types.int;
        readOnly = true;
      };
    font = {
      name = strOption "The font name";
      size = intOption "The font size";
    };
  in rec {
    secretsRootPath = strOption "Root path for secrets";
    user = strOption "The user name";
    machine = strOption "The machine(host) name";

    theme = { inherit font; };

    programs = {
      foot = { inherit font; };
      waybar = { inherit font; };
      sway = { inherit font; };
      rofi = { inherit font; };
      mako = { inherit font; };
    };
  };
}
