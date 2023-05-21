{ config, lib, pkgs, inputs, user, ... }:
with lib;
with builtins;
let
  cfg = config.system'.age;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (config.home-manager.users.${user}.home) homeDirectory;

  traverseFiles = dir:
    map
      (s: removePrefix "${toString dir}/" (toString s))
      (listFilesRecursive dir);

  # Like traverseFiles, but will only retain files ending in `.age`
  ageFiles = dir:
    lib.filter
      (name: hasSuffix ".age" name)
      (traverseFiles dir);

  # /a/b/file.age -> /a/b/file
  sanitizePath = path: removeSuffix ".age" (toString path);

  createAgeConfig = dir: listToAttrs
    (map
      (path: nameValuePair (sanitizePath path) { file = builtins.toPath "${dir}/${path}"; })
      (ageFiles dir));
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  options.system'.age = {
    enable = mkEnableOption "age config"; # // { default = true; };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ] ++ (with pkgs; [ rage ]);
    age = {
      secrets = createAgeConfig inputs.age-secrets;
      identityPaths = [
        "${homeDirectory}/.secrets/id_age"
      ];
    };
  };
}
