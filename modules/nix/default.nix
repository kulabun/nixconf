{
  pkgs,
  lib,
  ...
}:{
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
        substituters = https://cache.nixos.org https://nix-community.cachix.org https://chvp.cachix.org  https://accentor.cachix.org
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= chvp.cachix.org-1:eIG26KkeA+R3tCpvmaayA9i3KVVL06G+qB5ci4dHBT4= accentor.cachix.org-1:QP+oJwzmeq5Fsyp4Vk501UgUSbl5VIna/ard/XOePH8=
      '';
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 1d";
      };
      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };
    };
}
