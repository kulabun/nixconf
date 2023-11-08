{ config, lib, user, pkgs, pkgs', inputs, ... }:
with lib;
let
  cfg = config.shell'.dev-tools;

  nur = import inputs.nur {
    nurpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };
    pkgs = pkgs;
  };
in
{
  options.work'.dev-tools.enable = mkEnableOption "dev-tools";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      xdg.dataFile = {
        "dev/sdks-work".source = pkgs.linkFarm "local-sdks" [
          # {
          #   name = "zulu8";
          #   path = nur.repos.pokon548.zulu8;
          # }
          # {
          #   name = "zulu11";
          #   path = nur.repos.pokon548.zulu11;
          # }
          # {
          #   name = "zulu17";
          #   path = nur.repos.pokon548.zulu17.overrideAttrs (old: {
          #     nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.autoPatchelfHook ];
          #   });
          # }
        ];
      };

      home = {
        packages =
          with pkgs; [
            # Kafka
            kafkactl
            confluent-cli
          ];
      };
    };
  };
}
