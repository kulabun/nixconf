{ config, pkgs, lib, ... }:

let cfg = config.settings;
in { services.flameshot = { enable = true; }; }
