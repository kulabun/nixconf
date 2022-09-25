{ config, pkgs, lib, ... }:

let cfg = config.settings;
in { programs.fish = { enable = true; }; }
