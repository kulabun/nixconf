{lib, ...}: let
  inherit (lib) mkOption types;
in rec {
  mkOpt = type: description: mkOption {inherit type description;};

  mkStrOpt = description: mkOpt types.str description;
  mkIntOpt = description: mkOpt types.int description;
  mkBoolOpt = description: mkOpt types.bool description;
  mkEnableOpt = name: lib.mkEnableOption name;

  mkFontOpt = name: {
    name = mkStrOpt "${name} font name.";
    size = mkIntOpt "${name} font size.";
  };
}
