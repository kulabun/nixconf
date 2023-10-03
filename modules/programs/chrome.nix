{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.chrome;
in {
  options.programs'.chrome.enable = mkEnableOption "Chrome";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.chromium = {
        enable = true;
        package = pkgs.google-chrome;
        extensions = [
          "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
          "nngceckbapebfimnlniiiahkandclblb" # BitWarden
          "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
          "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
          "gbmdgpbipfallnflgajpaliibnhdgobh" # JSON Viewer
          "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        ];

        commandLineArgs = [
          "--enable-logging=stderr"
          "--ignore-gpu-blocklist"
          "--enable-webrtc-pipewire-capturer"
          "--use-vulkan"
          "--ozone-platform-hint=wayland"
        ];
      };
      programs.zsh = {
        shellAliases = {
          "chrome" = "google-chrome-stable";
        };
      };
    };
  };
}
