{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # helix-master = {
    #   url = "github:helix-editor/helix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.rust-overlay.follows = "rust-overlay";
    # };
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-22.05";
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
      (import inputs.rust-overlay)
      # (import inputs.helix-master)
    ];

    pkgs' = mkPkgs nixpkgs-unstable [];

    mylib = import ./lib {
      inherit pkgs inputs;
      lib = pkgs.lib;
    };

    homeConfig = {
      user,
      machine,
    }:
      home-manager.lib.homeManagerConfiguration rec {
        # inherit pkgs;
        # modules = [ ./options/settings ./home-manager/profiles/${machine} ];
        inherit pkgs;
        inherit system;
        extraSpecialArgs = {
          inherit system;
          inherit inputs;
          inherit mylib;
        };
        configuration = {
          config,
          pkgs,
          lib,
          ...
        }: {
          imports = [./hosts/${machine}];
        };
        username = user;
        homeDirectory = "/home/${username}";
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
