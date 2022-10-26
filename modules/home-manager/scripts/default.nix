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
  sway-make-screenshot =
    writeScriptBin "sway-make-screenshot"
      (builtins.readFile ./scripts/sway-make-screenshot.sh);
  rofi-gopass =
    writeScriptBin "rofi-gopass"
      (builtins.readFile ./scripts/rofi-gopass.sh);
  rofi-pinentry =
    writeScriptBin "rofi-pinentry"
      (builtins.readFile ./scripts/rofi-pinentry.sh);
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
    home = { packages = [ nx sway-make-screenshot rofi-gopass pass keys nix-prefetch-github scale-x ]; };
  };
}
