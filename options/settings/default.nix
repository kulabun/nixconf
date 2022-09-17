{ pkgs, config, lib, ... }:

with lib; {
  options.nixconf.settings = {
    secretsRootPath = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        Path to secrets root
      '';
    };
    user = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        The user name
      '';
    };
    machine = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        The machine name
      '';
    };
  };
}
