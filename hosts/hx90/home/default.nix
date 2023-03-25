{ config
, pkgs
, user
, host
, ...
}: rec {
  imports = [ 
    ../../../modules/home-manager 
  ];
  
  settings = {
    inherit user;
    machine = host; # TODO: rename machine -> host?
    # cursor = {
    #   theme = "capitaine-cursors-white";
    #   size = 32;
    # };

    fonts.enable = true;

    kitty.font = {
      name = "SauceCodePro Nerd Font";
      size = 9;
    };
    vscode.font = {
      name = "SauceCodePro Nerd Font";
      size = 12;
    };
  };

  home = {
    enableNixpkgsReleaseCheck = true;
    stateVersion = "22.11";

    sessionVariables = {
      GDK_SCALE = 2;
      # XCURSOR_SIZE = settings.cursor.size;
      # XCURSOR_THEME = settings.cursor.theme;
    };
    packages = with pkgs; [ ];
  };
}
