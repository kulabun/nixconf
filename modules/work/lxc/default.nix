{ config, lib, pkgs, pkgs', user, inputs, ... }:
with lib;
let
  inherit (config.home-manager.users.${user}.home) homeDirectory;
  cfg = config.work'.globalprotect-vpn;
  lxc-run = pkgs.writeScriptBin "lxc-run" (readFile ./bin/lxc-run.sh);
  indeed-shell = pkgs.writeScriptBin "indeed-shell" "lxc-run indeed zsh";
  indeed-start = pkgs.writeScriptBin "indeed-start" ''
    echo "Disconnecting from CloudFlare WARP.."
    sudo tailscale down
    warp-cli disconnect

    if [[ $(lxc list -c ns -f csv) == "indeed,RUNNING" ]]; then
      echo "Restarting indeed.."
      lxc restart indeed
    else
      echo "Starting indeed.."
      lxc start indeed
    fi

    echo "Waiting for indeed to start.."
    sleep 10

    echo "Configuring lxdbr0.."
    sudo ip link set mtu 1400 dev lxdbr0

    echo "Connecting to CloudFlare WARP.."
    warp-cli connect
  '';
  # indeed-alacritty = pkgs.makeDesktopItem {
  #   icon = "${pkgs.alacritty}/share/icons/hicolor/scalable/apps/Alacritty.svg";
  #   name = "Indeed Alacritty";
  #   genericName = "Terminal";
  #   categories = [ "System" "TerminalEmulator" ];
  #   desktopName = "Indeed Alacritty";
  #   startupWMClass = "Alacritty";
  #   exec = "${lxc-run}/bin/lxc-run indeed alacritty";
  # };
  # indeed-chrome = pkgs.makeDesktopItem {
  #   icon = "google-chrome";
  #   name = "Indeed Google Chrome";
  #   genericName = "Web Browser";
  #   categories = [ "Network" "WebBrowser" ];
  #   desktopName = "Indeed Chrome";
  #   startupWMClass = "Google-chrome";
  #   exec = "${lxc-run}/bin/lxc-run indeed google-chrome-stable";
  # };
  indeed-idea = pkgs.makeDesktopItem {
    icon = "idea-community";
    name = "Indeed IntelliJ IDEA";
    genericName = "IDE";
    categories = [ "Development" "IDE" ];
    desktopName = "Indeed Idea";
    startupWMClass = "jetbrains-idea-ce";
    exec = "${lxc-run}/bin/lxc-run indeed intellij-idea-community";
  };
  # indeed-slack = pkgs.makeDesktopItem {
  #   icon = "slack";
  #   name = "Indeed Slack";
  #   genericName = "Chat";
  #   categories = [ "Network" "Chat" ];
  #   desktopName = "Indeed Slack";
  #   startupWMClass = "Slack";
  #   exec = "${lxc-run}/bin/lxc-run indeed slack";
  # };
in
{
  options.work'.lxc = {
    enable = mkEnableOption "lxc work configuration";
  };

  config = mkIf cfg.enable {
    virtualisation'.lxc.enable = true;

    systemd.user.services = {
      indeed-vm = {
        description = "Indeed VM";
        wantedBy = [ "default.target" ];
        before = [ ];
        bindsTo = [ ];
        path = [ pkgs.sudo pkgs.lxd pkgs'.cloudflare-warp pkgs.iproute indeed-start ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          indeed-start
        '';
      };
    };
    # systemd.services = {
      # network-link-lxdbr0-setup = {
      #   description = "Link configuration for lxdbr0";
      #   wantedBy = [ "multi-user.target" ];
      #   before = [ "indeed-vm.target" ];
      #   after = [ "network-pre.target" "machines.target" ];
      #   path = [ pkgs.iproute ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = true;
      #   };
      #   # Fix MTU. Otherwise https would fail in cloudflare
      #   script = ''
      #     echo "Configuring lxdbr0..."
      #     ip link set mtu 1400 dev lxdbr0
      #   '';
      # };
    #
    #   indeed-vm = {
    #     description = "Indeed VM";
    #     wantedBy = [ "multi-user.target" ];
    #     before = [ ];
    #     bindsTo = [ ];
    #     after = [ "network-link-lxdbr0-setup.service" "machines.target" ];
    #     path = [ pkgs.sudo pkgs.lxd pkgs'.cloudflare-warp indeed-start ];
    #     serviceConfig = {
    #       Type = "oneshot";
    #       RemainAfterExit = true;
    #     };
    #     # TODO: should it rather be a user service?
    #     script = ''
    #       sudo --user klabun indeed-start
    #     '';
    #   };
    # };

    home-manager.users.${user} = {
      home = {
        packages = [
          lxc-run
          indeed-shell
          indeed-start
          # indeed-alacritty
          indeed-idea
          # indeed-slack
          # indeed-chrome
        ];
        # Hack to install configuration without making it immutable
        # Use `nixos-rebuild switch`, it will not be called for `boot`
        activation.work-lxc-setup = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" "restart-sops-nix" ] ''
          # Initialize home directory
          mkdir -p ${homeDirectory}/indeed/.config
          chown -R ${user}:${user} ${homeDirectory}/indeed/.config*

          mkdir -p ${homeDirectory}/indeed/.local
          chown -R ${user}:${user} ${homeDirectory}/indeed/.local*

          mkdir -p ${homeDirectory}/indeed/.gradle
          chown -R ${user}:${user} ${homeDirectory}/indeed/.gradle*

          mkdir -p ${homeDirectory}/indeed/.ssh/sops
          chown -R ${user}:${user} ${homeDirectory}/indeed/.ssh*

          mkdir -p ${homeDirectory}/indeed/indeed
          mkdir -p ${homeDirectory}/indeed/share
          mkdir -p ${homeDirectory}/indeed/sys/bin
          mkdir -p ${homeDirectory}/indeed/sys/etc/lxc
          chown -R ${user}:${user} ${homeDirectory}/indeed

          # Copy over ssh keys and configuration
          cat ${homeDirectory}/indeed/.sops/indeed > ${homeDirectory}/indeed/.ssh/sops/indeed
          chmod 600 ${homeDirectory}/indeed/.ssh/sops/indeed
          cat ${homeDirectory}/indeed/.sops/indeed_rsa > ${homeDirectory}/indeed/.ssh/sops/indeed_rsa
          chmod 600 ${homeDirectory}/indeed/.ssh/sops/indeed_rsa

          cp ${homeDirectory}/secrets/work/ssh/config ${homeDirectory}/indeed/.ssh/sops/config
          cp ${homeDirectory}/secrets/work/ssh/indeed.pub ${homeDirectory}/indeed/.ssh/sops/indeed.pub
          cp ${homeDirectory}/secrets/work/ssh/indeed_rsa.pub ${homeDirectory}/indeed/.ssh/sops/indeed_rsa.pub

          # Add files
          cat ${./files/bootstrap.sh} > ${homeDirectory}/indeed/sys/bin/bootstrap.sh
          chmod +x ${homeDirectory}/indeed/sys/bin/bootstrap.sh

          cat ${./files/update.sh} > ${homeDirectory}/indeed/sys/bin/update.sh
          chmod +x ${homeDirectory}/indeed/sys/bin/update.sh

          cat ${./files/indeed.yml} > ${homeDirectory}/indeed/sys/etc/lxc/indeed.yml

          # Config Files
          mkdir -p ${homeDirectory}/indeed/config/git
          chown -R ${user}:${user} ${homeDirectory}/indeed/config
          chmod -R 700 ${homeDirectory}/indeed/config
          cat ${./config/starship.toml} > ${homeDirectory}/indeed/.config/starship.toml
          cat ${./config/git/config} > ${homeDirectory}/indeed/config/git/config
          cat ${./config/zshrc} > ${homeDirectory}/indeed/config/zshrc
          cat ${./config/gradle.properties} > ${homeDirectory}/indeed/.gradle/gradle.properties

          # Gitignore
          mkdir -p ${homeDirectory}/indeed/.config/git
          chown -R ${user}:${user} ${homeDirectory}/indeed/.config/git
          chmod -R 700 ${homeDirectory}/indeed/.config/git
          cat ${./config/git/ignore} > ${homeDirectory}/indeed/.config/git/ignore
        '';
      };
    };
  };
}
