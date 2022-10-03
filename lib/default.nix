{
  inputs,
  lib,
  pkgs,
  ...
}: let
  # inherit (lib) foldr;
  # importModule = file: import file {inherit lib pkgs inputs;};
  # mylib = foldr (a: b: a // b) {} [
  #   (importModule ./options.nix)
  # ];
  mylib = import ./options.nix {inherit lib pkgs inputs;};
in
  mylib
