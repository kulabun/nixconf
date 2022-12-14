{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # neovim-kl.url = "path:/home/konstantin/projects/neovim-flake";
    neovim-kl.url = "github:kulabun/neovim-flake";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    # helix-master = {
    #   url = "github:helix-editor/helix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.rust-overlay.follows = "rust-overlay";
    # };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    mkPkgs = pkgs: overlays:
      import pkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };

    pkgs = mkPkgs nixpkgs [
      (import ./overlay)
      # (import inputs.rust-overlay)
      (import inputs.neovim-nightly-overlay)
      (
        final: prev: {
          neovim-kl = inputs.neovim-kl.packages.${system}.neovim-kl;
        }
      )
      # (import inputs.helix-master)
    ];

    pkgs' = mkPkgs nixpkgs-unstable [];

    mylib = import ./lib {
      inherit pkgs inputs;
      lib = pkgs.lib;
    };

    homeConfig = {
      machine,
    }:
      home-manager.lib.homeManagerConfiguration rec {
        inherit pkgs;
        modules = [ ./hosts/${machine}/home ];
        extraSpecialArgs = {
          inherit system;
          inherit inputs;
          inherit mylib;
          inherit pkgs';
        };
      };
  in
    with pkgs.lib;
    with mylib; {
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
            ./modules/nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."konstantin" = {imports = [./hosts/hx90/home];};
                extraSpecialArgs = {
                  inherit system;
                  inherit inputs;
                  inherit mylib;
                  inherit pkgs';
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
          machine = "dell5560";
        };
      };
    };
}
