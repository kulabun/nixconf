{ config, lib, ... }:
with lib;
let cfg = config.system'.sysctl;
in {
  options.system'.sysctl = {
    enable = mkEnableOption "sysctl config" // { default = true; };
  };

  config = mkIf cfg.enable {
    # Use swap when necessary, but prefer to keep things in memory
    boot.kernel.sysctl = { "vm.swappiness" = 10; };
  };
}
