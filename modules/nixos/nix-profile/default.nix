{ config
, pkgs
, lib
, nixProfile
, ...
}: with lib; {
  config = mkIf (nixProfile != null) {
    environment.sessionVariables = {
      NIX_PROFILE = nixProfile;
    };
  };
}
