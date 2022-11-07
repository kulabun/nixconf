{
  inputs,
  system,
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.neovim.enable = mkEnableOpt "neovim";
  };

  config = mkIf config.settings.neovim.enable {
    xdg.configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconf/modules/home-manager/neovim/config";
        recursive = true;
      };
      # "nvim" = {
      #   source = pkgs.fetchFromGitHub {
      #     owner = "AstroNvim";
      #     repo = "AstroNvim";
      #     rev = "893665a969129eb528e54b7e4bee1e6c952d6d25";
      #     sha256 = "1wm4lpm3j4k6njf620ncq9gpy0zkrqgijzbg6y9jahb3wxl1qz15";
      #   };
      #   recursive = true;
      # };
      # "nvim/lua/user" = {
      #   # Unfortunately with Flakes ./config does not work as expected, so the url is provided as a string
      #   # https://github.com/nix-community/home-manager/issues/2085
      #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconf/modules/home-manager/neovim/config";
      #   #recursive = true;
      # };
    };

    programs.zsh.shellAliases = {
      vim = "nvim";
      vi = "vim";
    };

    home = {
      # sessionVariables = {
      #   EDITOR = "nvim";
      #   VISUAL = "nvim";
      # };

      packages = with pkgs; [
        neovim-nightly
        python3Packages.pynvim
        nodePackages.neovim
        neovide
      ];
    };
  };
}
