{ pkgs, ... }:
let
  inherit
    (pkgs)
    bash
    findutils
    fzf
    tz
    tzdata
    ;
in
pkgs.writeScriptBin "tz" ''
  #!${bash}/bin/bash
  set -euo pipefail

  ${findutils}/bin/find ${tzdata}/share/zoneinfo/ -maxdepth 2 -type f \
    | sed "s_${tzdata}/share/zoneinfo/__" \
    | ${fzf}/bin/fzf --prompt="Timezone: " --height 20% --reverse \
    | xargs -I{} ${tz}/bin/tz {}
''
