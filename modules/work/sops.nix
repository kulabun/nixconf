{ config, lib, user, inputs, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.work'.sops;
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
  options.work'.sops = {
    enable = mkEnableOption "work sops config";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      system'.sops.enable = true;

      # sops daemon starts on boot
      home-manager.users.${user} = {
        sops = {
          secrets = mkMerge [
            (createSopsConfig { source = "${inputs.sops-secrets}/work/ssh"; target = "${homeDirectory}/indeed/.sops/ssh"; })
          ];
          age.keyFile = "${homeDirectory}/.secrets/id_age";
        };
      };
    })
  ];
}
