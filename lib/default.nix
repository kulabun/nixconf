{
  inputs,
  lib,
  pkgs,
  ...
}: let
  options = import ./options.nix {inherit lib pkgs inputs;};
  webapp = import ./webapp {inherit lib pkgs inputs;};
in
  options // webapp
