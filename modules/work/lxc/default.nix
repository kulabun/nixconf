{ config, lib, pkgs, user, inputs, ... }:
with lib;
let
  inherit (config.home-manager.users.${user}.home) homeDirectory;
  cfg = config.work'.globalprotect-vpn;
  lxc-run = pkgs.writeScriptBin "lxc-run" (readFile ./bin/lxc-run.sh);
in
{
  options.work'.lxc = {
    enable = mkEnableOption "lxc work configuration";
  };

  config = mkIf cfg.enable {
    virtualisation'.lxc.enable = true;

    home-manager.users.${user} = {
      home = {
        packages = [
          lxc-run
        ];
        # Hack to install configuration without making it immutable
        # Use `nixos-rebuild switch`, it will not be called for `boot`
        activation.work-lxc-setup = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          mkdir -p ${homeDirectory}/indeed/indeed
          mkdir -p ${homeDirectory}/indeed/share
          mkdir -p ${homeDirectory}/indeed/.config
          mkdir -p ${homeDirectory}/indeed/.local
          mkdir -p ${homeDirectory}/indeed/.gradle

          mkdir -p ${homeDirectory}/indeed/sys/bin
          mkdir -p ${homeDirectory}/indeed/sys/etc/lxc
          chown -R ${user}:${user} ${homeDirectory}/indeed

          cat ${./files/bootstrap.sh} > ${homeDirectory}/indeed/sys/bin/bootstrap.sh
          chmod +x ${homeDirectory}/indeed/sys/bin/bootstrap.sh

          cat ${./files/indeed.yml} > ${homeDirectory}/indeed/sys/etc/lxc/indeed.yml
        '';
      };
    };
  };
}
