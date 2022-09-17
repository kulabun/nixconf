{
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-22.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # helix-master = {
    #   url = "github:helix-editor/helix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.rust-overlay.follows = "rust-overlay";
    # };

    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlay)
          (import inputs.rust-overlay)
          # (import inputs.helix-master)
        ];
        config.allowUnfree = true;
      };

      homeConfig = { user, machine }:
        home-manager.lib.homeManagerConfiguration rec {
          # inherit pkgs;
          # modules = [ ./options/settings ./home-manager/profiles/${machine} ];
          inherit pkgs;
          inherit system;
          extraSpecialArgs = {
            inherit system;
            inherit inputs;
          };
          configuration = { config, pkgs, lib, ... }: {
            imports = [ ./options/settings ./home-manager/profiles/${machine} ];
            config.nixconf.settings = {
              inherit user;
              inherit machine;
              secretsRootPath = "${homeDirectory}/secrets";
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
                  #name = "JetBrainsMono Nerd Font";
                  name = "SauceCodePro Nerd Font";
                  size = 10;
                };
                rofi.font = {
                  name = "JetBrainsMono Nerd Font";
                  #name = "SauceCodePro Nerd Font";
                  #name = "Robot";
                  size = 9;
                };
                mako.font = {
                  #name = "JetBrainsMono Nerd Font";
                  name = "Roboto";
                  size = 9;
                };
              };
            };
          };
          username = user;
          homeDirectory = "/home/${username}";
        };
      fhdFontsConfig = {
        sway.font.size = 10;
        foot.font.size = 9;
        waybar.font.size = 10;
        rofi.font.size = 10;
        mako.font.size = 10;
      };
    in {
      #isoImage = (baseSystem {
      #  system = "x86_64-linux";
      #  modules = [
      #    ./profiles/iso.nix
      #  ];
      #});

      nixosConfigurations = {
        hx90 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/profiles/hx90 ];
        };
      };

      homeConfigurations = {
        hx90 = homeConfig {
          user = "konstantin";
          machine = "hx90";
        };
        dell5560 = homeConfig {
          user = "klabun";
          machine = "dell5560";
        };
      };
    };
}
