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
  options = import ./options.nix {inherit lib pkgs inputs;};
  webapp = import ./webapp {inherit lib pkgs inputs;};
in
  options // webapp
