{ config, lib, user, inputs, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.system'.sops;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (config.home-manager.users.${user}.home) homeDirectory;

  traverseFiles = dir:
    map
      (s: removePrefix "${toString dir}/" (toString s))
      (listFilesRecursive dir);

  # Like traverseFiles, but will only retain files ending in `.enc{,.yaml,.json}`
  sopsFiles = dir:
    filter
      (name:
        let
          isJSON = hasSuffix ".enc.json" name;
          isYAML = hasSuffix ".enc.yaml" name;
          isRaw = hasSuffix ".enc" name;
        in
        isJSON || isYAML || isRaw)
      (traverseFiles dir);

  # a/b/file.enc.json -> a/b/file
  sanitizePath = path: removeSuffix ".enc" (removeSuffix ".yaml" (removeSuffix ".json" (builtins.unsafeDiscardStringContext (toString path))));

  createSopsConfig = { source, target, config ? { } }: listToAttrs
    (map
      (file:
        nameValuePair (sanitizePath file) (
          {
            sopsFile = "${source}/${file}";
            path = "${target}/${sanitizePath file}";
          }
          // config
          // optionalAttrs (hasSuffix ".enc" file) { format = "binary"; }
          // optionalAttrs (hasSuffix ".enc.json" file) { format = "json"; }
          // optionalAttrs (hasSuffix ".enc.yaml" file) { format = "yaml"; }
        ))
      (sopsFiles source));
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.system'.sops = {
    enable = mkEnableOption "sops config" // { default = true; };
  };

  config = mkMerge [
    (mkIf cfg.enable {

      # By default keys are owned by root:keys
      users.users.${user}.extraGroups = [ config.users.groups.keys.name ];

      environment.systemPackages = with pkgs; [ sops age ];

      # system level sops secrets are decrypted on activation script
      sops = {
        defaultSopsFile = ./.sops.yaml;
        age = {
          keyFile = "${homeDirectory}/.secrets/id_age";
          generateKey = false;
        };
        secrets = mkMerge [
          (createSopsConfig {
            source = "${inputs.sops-secrets}/ssh/keys";
            target = "/etc/ssh/sops";
            config = {
              mode = "0600";
              owner = "root";
              group = config.users.groups.keys.name;
            };
          })
          {
            "config-sops" = {
              sopsFile = "${inputs.sops-secrets}/ssh/config/root.enc";
              path = "/etc/ssh/sops/config";
              mode = "0600";
              format = "binary";
            };
          }
        ];
        # secrets.<fileName> = {
        #   sopsfile = ./path-to-secret;
        #   mode = "0440";
        #   owner = user;
        # };
      };

      # sops daemon starts on boot
      home-manager.users.${user} = {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        sops = {
          secrets = mkMerge [
            (createSopsConfig { source = "${inputs.sops-secrets}/ssh/keys"; target = "${homeDirectory}/.ssh/sops"; })
            {
              "config-sops" = {
                sopsFile = "${inputs.sops-secrets}/ssh/config/user.enc";
                path = "${homeDirectory}/.ssh/sops/config";
                mode = "0600";
                format = "binary";
              };
            }
          ];
          age.keyFile = "${homeDirectory}/.secrets/id_age";
        };

        home.packages = with pkgs; [ sops age ];

        home.activation.restart-sops-nix = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          ${pkgs.systemd}/bin/systemctl --user restart sops-nix
        '';
      };
    })
  ];
}
