{ config
, pkgs
, lib
, ...
}:
with lib; {
  options = {
    settings.google-cloud-sdk.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables google-cloud-sdk";
    };
  };

  config = mkIf config.settings.google-chrome.enable {
    home.packages = with pkgs; [ google-cloud-sdk ];
  };
}
