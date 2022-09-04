{ pkgs, config, lib, ... }:

with lib; {
  options.nixconf.settings = {
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
