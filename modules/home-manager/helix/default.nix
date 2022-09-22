{ config, pkgs, lib, ... }: {
  xdg.configFile = {
    "helix" = {
      source = ./config;
      recursive = true;
    };
  };

  home = {
    packages = let
      my-helix = pkgs.helix.overrideAttrs (old: rec {
        version = "22.08.01";
        src = pkgs.fetchFromGitHub {
          owner = "helix-editor";
          repo = old.pname;
          rev = "${version}";
          fetchSubmodules = true;
          sha256 = "sha256-pqAhUxKeFN7eebVdNN3Ge38sA30SUSu4Xn4HDZAjjyY=";
        };
        cargoSha256 = "sha256-idItRkymr+cxk3zv2mPBR/frCGvzEUdSAhY7gghfR3M=";
        cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
          inherit src;
          name = "${old.pname}-vendor.tar.gz";
          outputHash = "sha256-V3be7onL/A4Ib9E2S6oW7HSE93jgKFSGZkf9m2BMs4w=";
        });
      });
    in with pkgs; [ my-helix ];
  };
}
