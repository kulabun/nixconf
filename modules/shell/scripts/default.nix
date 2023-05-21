{ config
, lib
, user
, pkgs
, ...
}:
with lib;
with pkgs; let
  cfg = config.shell'.scripts;
  # pass = writeScriptBin "pass" (builtins.readFile ./scripts/pass.sh);
  # keys = writeScriptBin "keys" (builtins.readFile ./scripts/keys.sh);
  # nix-prefetch-github = writeScriptBin "nix-prefetch-github" (builtins.readFile ./scripts/nix-prefetch-github.sh);
  # nx = writeScriptBin "nx" (builtins.readFile ./scripts/nx.sh);
  tz = import ./scripts/tz.nix { inherit lib pkgs; };
in
{
  options.shell'.scripts.enable = mkEnableOption "scripts";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ tz ];
    };
  };
}
