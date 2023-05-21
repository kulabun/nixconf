# Configuration is based on
#   https://github.com/LunNova/nixos-configs/blob/dev/users/lun/on-nixos/kdeconfig.nix
{ config, lib, pkgs, ... }:
with lib;
let
  isNixOS = builtins.pathExists /etc/NIXOS;

  toValue = with builtins; v:
    if isString v then
      v
    else if isBool v then
      boolToString v
    else if isInt v then
      toString v
    else if isFloat v then
      toString v
    else
      abort ("Unknown value type: ${toString v}");

  # accepts configuration as an attribute set of following format:
  # { 
  #  <fileName1> = { <groupName> = { <key> = <value>; }; 
  #  <fileName2> = { <groupName> = { <key> = <value>; }; 
  # }
  toKWriteConfigCommands = configuration: flatten (mapAttrsToList
    (file:
      mapAttrsToList
        (groups:
          mapAttrsToList
            (key: value:
              ''
                $DRY_RUN_CMD ${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5 --file $confdir/'${file}' \
                  ${lib.concatStringsSep " " (map (group: "--group '" + group + "'") (lib.splitString "+" groups))} \
                  --key '${key}' ${if (isNull value) then "--delete" else ("'" + (toValue value) + "'")}
              '')
        ))
    configuration);

  # Hack to install configuration without making it immutable
  # Use `nixos-rebuild switch`, it will not be called for `boot`
  writeConfigurationScript = configuration: ''
    _() {
      confdir="''${XDG_CONFIG_HOME:-$HOME/.config}"
      ${builtins.concatStringsSep "\n" (toKWriteConfigCommands configuration)}
      $DRY_RUN_CMD ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.KWin /KWin reconfigure || echo "KWin reconfigure failed"
      for i in {0..10}; do
        $DRY_RUN_CMD ${pkgs.dbus}/bin/dbus-send --type=signal /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:$i int32:0 || echo "KGlobalSettings.notifyChange failed"
      done
    } && _
    unset -f _
  '';
in
writeConfigurationScript
