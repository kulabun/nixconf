{
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-22.05";
    rust-overlay.url = "github:oxalica/rust-overlay";

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
      rust-overlay = inputs.rust-overlay;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ 
          (import ./overlay) 
          #(import rust-overlay)
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
            };
          };
          username = user;
          homeDirectory = "/home/${username}";
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
          modules = [ ./nixos/hx90 ];
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
