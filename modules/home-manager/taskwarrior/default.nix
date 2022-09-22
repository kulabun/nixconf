{ config, pkgs, ... }:
let cfg = config.settings;
in { programs = { taskwarrior.enable = true; }; }

