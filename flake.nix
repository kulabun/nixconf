{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    alacritty-theme = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };

    catppuccin-zellij = {
      url = "github:catppuccin/zellij";
      flake = false;
    };

    kl-nvim = {
      url = "github:kulabun/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-secrets = {
      # url = "path:/home/klabun/secrets";
      # url = "path:/home/konstantin/secrets";
      url = "git+ssh://master.codecommit/v1/repos/secrets?ref=main";
      flake = false;
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , ...
    }:
    let
      stateVersion = "22.11";
      mkPkgs = { pkgs, system, overlays ? [ ] }:
        import pkgs {

          inherit system;
          overlays = overlays ++ [
            inputs.agenix.overlays.default
            inputs.kl-nvim.overlays.default
          ];
          config.allowUnfree = true;
        };
      pkgs = system: mkPkgs { pkgs = (inputs.nixpkgs); inherit system; };
      pkgs' = system: mkPkgs { pkgs = (inputs.nixpkgs-unstable); inherit system; };
      lib = system: (pkgs system).lib // { my = import ./lib { }; };
    in
    {
      nixosConfigurations = {
        hx90 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit stateVersion;
            pkgs = pkgs system;
            pkgs' = pkgs' system;
            lib = lib system;
            user = "konstantin";
          };
          modules = [
            ./modules
            ./nixos/hosts/hx90
          ];
        };
        dell7573 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit stateVersion;
            pkgs = pkgs system;
            pkgs' = pkgs' system;
            lib = lib system;
            user = "klabun";
          };
          modules = [
            ./modules
            ./nixos/hosts/dell7573
          ];
        };
      };

      homeConfigurations = {
        #   dell5560 = home-manager.lib.homeManagerConfiguration {
        #     system = "x86_64-linux";
        #     username = "klabun";
        #     homeDirectory = "/home/klabun";
        #
        #     configuration = import ./hm/dell5560 {
        #       inherit inputs;
        #       inherit stateVersion;
        #       inherit pkgs;
        #       inherit pkgs';
        #       inherit (pkgs) lib;
        #     };
        #     extraSpecialArgs.flake-inputs = inputs;
        #   };
      };
    };
}
