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
            imports = [ ./hosts/${machine} ];
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
          inherit pkgs;
          modules = [
            ./hosts/hx90
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."konstantin" = { imports = [ ./hosts/hx90/home ]; };
                extraSpecialArgs = {
                  inherit system;
                  inherit inputs;
                };
              };
            }
          ];
        };
      };

      homeConfigurations = {
        # hx90 = homeConfig {
        #   user = "konstantin";
        #   machine = "hx90";
        # };
        dell5560 = homeConfig {
          user = "klabun";
          machine = "dell5560";
        };
      };
    };
}
