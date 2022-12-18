{ config
, pkgs
, lib
, mylib
, ...
}:
with pkgs; let
  helloworld =
    writeScriptBin "helloworld"
      (builtins.readFile ./scripts/helloworld.sh);
  pass = writeScriptBin "pass" (builtins.readFile ./scripts/pass.sh);
  keys = writeScriptBin "keys" (builtins.readFile ./scripts/keys.sh);
  nix-prefetch-github = writeScriptBin "nix-prefetch-github" (builtins.readFile ./scripts/nix-prefetch-github.sh);
  nx = writeScriptBin "nx" (builtins.readFile ./scripts/nx.sh);
  scale-x = writeScriptBin "scale-x" (builtins.readFile ./scripts/scale-x.sh);
in
with lib;
with mylib; {
  options = {
    settings.scripts.enable = mkEnableOpt "scripts";
  };

  config = mkIf config.settings.scripts.enable {
    home = { packages = [ nx pass keys nix-prefetch-github scale-x ]; };
  };
}
