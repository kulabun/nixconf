{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
let
  cfg = config.settings.vscode;
  my-vscode = with pkgs;
    # Use custom approach because of non-consistent results for multiplatform packages with vscode-utils.buildscodeMarketplaceExtension.
    # See https://github.com/NixOS/nixpkgs/issues/197682
    vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [ ms-python.python ] 
        ++ map
          (extension: vscode-utils.buildVscodeExtension (extension // { src = fetchurl extension.src; }))
          (import ./extensions.nix).extensions;
    };
in
with lib;
with mylib; {
  options = {
    settings.vscode = {
      enable = mkEnableOpt "vscode";
      font = mkFontOpt "vscode";
    };
  };

  config = mkIf config.settings.vscode.enable {
    xdg.configFile."Code/User/settings.json".source = ./config/settings.json;
    home.packages = [
      my-vscode
    ];
    home = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
