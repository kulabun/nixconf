{ config, pkgs, lib, ... }:

with pkgs;
let
  helloworld = writeShellScriptBin "helloworld"
    (builtins.readFile ./scripts/helloworld.sh);
  sway-make-screenshot = writeShellScriptBin "sway-make-screenshot"
    (builtins.readFile ./scripts/sway-make-screenshot.sh);
  rofi-gopass = writeShellScriptBin "rofi-gopass"
    (builtins.readFile ./scripts/rofi-gopass.sh);
  rofi-pinentry = writeShellScriptBin "rofi-pinentry"
    (builtins.readFile ./scripts/rofi-pinentry.sh);
  pass = writeShellScriptBin "pass" (builtins.readFile ./scripts/pass.sh);
  keys = writeShellScriptBin "keys" (builtins.readFile ./scripts/keys.sh);
  nx = pkgs.writeShellScriptBin "nx" (builtins.readFile ./scripts/nx.sh);
  hm = pkgs.writeShellScriptBin "hm" (builtins.readFile ./scripts/hm.sh);
in {
  home = { packages = [ nx hm sway-make-screenshot rofi-gopass pass keys ]; };
}
