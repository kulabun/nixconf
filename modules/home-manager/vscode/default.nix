{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
let
  cfg = config.settings.vscode;
  vscode-neovim = pkgs.writeShellScriptBin "vscode-neovim" ''
    export XDG_DATA_HOME=$HOME/.vscode-neovim/local
    export XDG_CONFIG_HOME=$HOME/.vscode-neovim/config
    export XDG_CACHE_HOME=$HOME/.vscode-neovim/cache
    export XDG_STATE_HOME=$HOME/.vscode-neovim/state
    ${pkgs.neovim-nightly}/bin/nvim "$@"
  '';

  my-vscode = with pkgs';
    # Use custom approach because of non-consistent results for multiplatform packages with vscode-utils.buildscodeMarketplaceExtension.
    # See https://github.com/NixOS/nixpkgs/issues/197682
    vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [ ms-python.python ] 
        ++ filter (name: name != "ms-python.python") (map
          (extension: vscode-utils.buildVscodeExtension (extension // { src = fetchurl extension.src; }))
          (import ./extensions.nix).extensions);
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
    xdg.configFile."Code/User/settings.json" = {
      # TODO: I should put a path to nixconf root to a dedicated property
      # Unfortunately with Flakes ./config does not work as expected, so the url is provided as a string
      # https://github.com/nix-community/home-manager/issues/2085
      # source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconf/modules/home-manager/vscode/config/settings.json";
        source = pkgs.substituteAll {
          src = ./config/settings.json;
          neovimBin = "${vscode-neovim}/bin/vscode-neovim";
        };
    };
    home.file.".vscode-neovim" = {
      # Unfortunately with Flakes ./config does not work as expected, so the url is provided as a string
      # https://github.com/nix-community/home-manager/issues/2085
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconf/modules/home-manager/vscode/config/vscode-neovim";
      recursive = true;
    };
    home.packages = [
      vscode-neovim
      my-vscode
    ];
    home = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
