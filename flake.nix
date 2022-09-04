{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      homeConfig = { user, machine }:
        home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          inherit system;
          configuration = { pkgs, lib, ... }: {
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
