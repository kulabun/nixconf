{ ... }: {
  imports = [ ./settings/default.nix ];

  settings = {
    user = "konstantin";
    machine = "hx90";
    secretsRootPath = "/home/konstantin/secrets";

    programs = {
      sway.font = {
        name = "SauceCodePro Nerd Font";
        size = 9;
      };
      foot.font = {
        name = "SauceCodePro Nerd Font";
        size = 9;
      };
      waybar.font = {
        name = "SauceCodePro Nerd Font";
        size = 10;
      };
      rofi.font = {
        name = "JetBrainsMono Nerd Font";
        size = 9;
      };
      mako.font = {
        name = "JetBrainsMono Nerd Font";
        size = 9;
      };
    };
  };
}
