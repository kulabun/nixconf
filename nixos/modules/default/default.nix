{ pkgs, ... }: {
  imports = [
    ../kint-keyboard/default.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      docker-compose
      vlc
      firefox-wayland
      google-chrome
    ];
    sessionVariables = rec { };
  };
}
