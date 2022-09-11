{ config, pkgs, lib, ... }:

with pkgs;
let
  helloworld = writeShellScriptBin "helloworld"
    (builtins.readFile ./scripts/helloworld.sh);
  sway-make-screenshot = writeShellScriptBin "sway-make-screenshot"
    (builtins.readFile ./scripts/sway-make-screenshot.sh);
  rofi-gopass = writeShellScriptBin "rofi-gopass"
    (builtins.readFile ./scripts/rofi-gopass.sh);
  rofi-pinentry = writeShellScriptBin "rofi-pinentry"
    (builtins.readFile ./scripts/rofi-pinentry.sh);
  pass = writeShellScriptBin "pass"
    (builtins.readFile ./scripts/pass.sh);

  cfg = config.nixconf.settings;
  nx = pkgs.writeShellScriptBin "nx" ''
    cmd="$1"
    case $cmd in
      update)
        nix flake update --commit-lock-file /home/${cfg.user}/nixconf --extra-experimental-features "nix-command flakes";
        sudo nixos-rebuild boot --flake /home/${cfg.user}/nixconf#${cfg.machine};
        ;;

      boot)
        sudo nixos-rebuild boot --flake /home/${cfg.user}/nixconf#${cfg.machine};
        ;;

      build)
        sudo nixos-rebuild build --flake /home/${cfg.user}/nixconf#${cfg.machine};
        ;;

      clean)
        sudo nix-collect-garbage -d;
        ;;

      index)
        nix-index
        ;;
        
      locate)
        nix-locate
        ;;

      edit)
        fd . '/home/${cfg.user}/nixconf' | fzf | xargs -L1 $EDITOR
        ;;

      *)
        echo "$cmd is not a known command"
        ;;
    esac
  '';
  hm = pkgs.writeShellScriptBin "hm" ''
    cmd="$1"
    case $cmd in
      update)
        nix flake update --commit-lock-file /home/${cfg.user}/nixconf --extra-experimental-features "nix-command flakes";
        home-manager switch --flake /home/${cfg.user}/nixconf#${cfg.machine} --extra-experimental-features "nix-command flakes";
        ;;

      switch)
        home-manager switch --flake /home/${cfg.user}/nixconf#${cfg.machine} --extra-experimental-features "nix-command flakes";
        ;;

      build)
        home-manager build --flake /home/${cfg.user}/nixconf#${cfg.machine} --extra-experimental-features "nix-command flakes";
        ;;

      clean)
        nix-collect-garbage -d;
        ;;

      index)
        nix-index
        ;;
        
      locate)
        nix-locate
        ;;

      edit)
        fd . '/home/${cfg.user}/nixconf' | fzf | xargs -L1 $EDITOR
        ;;

      *)
        echo "$cmd is not a known command"
        ;;
    esac
  '';
in { home.packages = [ nx hm sway-make-screenshot rofi-gopass pass ]; }
