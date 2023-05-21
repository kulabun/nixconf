{ config
, lib
, user
, pkgs
, ...
}:
with lib; let
  cfg = config.shell'.utils;
in
{
  options.shell'.utils.enable = mkEnableOption "utils" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        bat # cat
        czkawka # find duplicate files, large files, etc
        diskonaut # find and visualize large files
        dogdns # dig (dns lookup)
        du-dust # du
        duf # df
        exa # ls
        fd # find
        ouch # compress / unpompress any file
        procs # ps
        ripgrep # grep
        sd # sed
        xh # curl
        xh # curl

        dmidecode # hardware info
        inxi # system + hardware info
        lshw # list hardware
        lsof # list open files
        nvme-cli # nvme info
        smartmontools # disk info
      ];

      programs.zsh.shellAliases = {
        cat = "${pkgs.bat}/bin/bat --plain";
        cz = "${pkgs.czkawka}/bin/czkawka_cli";
        df = "${pkgs.duf}/bin/duf";
        dig = "${pkgs.dogdns}/bin/dog";
        dk = "${pkgs.diskonaut}/bin/diskonaut";
        du = "${pkgs.du-dust}/bin/dust -b -r";
        fd = "${pkgs.fd}/bin/fd";
        g = "${pkgs.git}/bin/git";
        grep = "${pkgs.ripgrep-all}/bin/rga --color=auto";
        ls = "${pkgs.exa}/bin/exa --color=auto";
        ps = "${pkgs.procs}/bin/procs";
        py = "${pkgs.python3}/bin/python3";
        sd = "${pkgs.sd}/bin/sd";
        xh = "${pkgs.xh}/bin/xh";

        pack = "${pkgs.ouch}/bin/ouch compress";
        unpack = "${pkgs.ouch}/bin/ouch decompress";
      };
    };
  };
}
