{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.virtualisation'.lxc;
  lxd-seed = pkgs.writeShellScriptBin "lxd-seed" ''
    exec ${pkgs.lxd}/bin/lxd init --preseed < ${./config/preseed.yml}
  '';
in
{
  options.virtualisation'.lxc = {
    enable = mkEnableOption "lxc";
  };

  config = mkIf cfg.enable {
    virtualisation.lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };

    virtualisation.lxc = {
      enable = true;
      lxcfs.enable = true;
    };

    users = {
      users.${user}.extraGroups = [ "lxd" ];
    };

    environment.systemPackages = [
      lxd-seed
    ];

    boot = {
      # ip forwarding is needed for NAT'ing to work.
      kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv4.conf.default.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
        "net.ipv6.conf.default.forwarding" = true;

        # Disable netfilter for bridges.
        # NOTE: means bridge-routed frames do not go through iptables
        # https://bugzilla.redhat.com/show_bug.cgi?id=512206#c0
        "net.bridge.bridge-nf-call-ip6tables" = 0;
        "net.bridge.bridge-nf-call-iptables" = 0;
        "net.bridge.bridge-nf-call-arptables" = 0;
      };

      # kernel module for forwarding to work
      kernelModules = [ "nf_nat_ftp" ];
    };
  };
}
