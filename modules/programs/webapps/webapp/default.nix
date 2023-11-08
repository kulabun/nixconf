{ pkgs, ... }:
rec {
  inherit (pkgs.lib) concatStringsSep optionalString;

  makeElectronApp = { name, wmClass, url, clearUserAgent }:
    pkgs.callPackage
      ({ pkgs
       , stdenv
       ,
       }:
        let
          electron = pkgs.electron_27;
          extraArgs = concatStringsSep " " [
            (optionalString (wmClass != null) "--wmclass='${wmClass}'")
            "--title=${name}" # the title is used in addition to wmclass(app_id) to make apps share profile but differenciate them
            (optionalString clearUserAgent "--clear-user-agent")
          ];
        in
        stdenv.mkDerivation {
          inherit name;
          src = ./src;
          buildInputs = [ electron ];
          phases = [ "buildPhase" ];
          buildPhase = ''
            mkdir -p $out/lib/${name}
            cp -r $src/* $out/lib/${name}
            echo '{"main":"main.js"}' > $out/lib/${name}/package.json
            cat ${./src/webapp.main.js} > $out/lib/${name}/main.js
            mkdir -p $out/bin
            echo '#!/bin/sh' > $out/bin/${name}
            echo "systemd-cat --identifier=${name} -- ${electron}/bin/electron --enable-features=UseOzonePlatform --ozone-platform=wayland ${extraArgs} --url=${url} $out/lib/${name}" >> $out/bin/${name}
            chmod +x $out/bin/${name}
          '';
        })
      { };
  makeWebApp =
    { name
    , desktopName
    , icon
    , url
    , wmClass ? null
    , clearUserAgent ? true # should be false for google apps
    , categories ? [ ]
    ,
    }:
    pkgs.makeDesktopItem {
      inherit icon;
      inherit categories;
      inherit name;
      inherit desktopName;
      startupWMClass = name;
      exec = "${makeElectronApp {
        inherit name;
        inherit url;
        inherit wmClass;
        inherit clearUserAgent;
      }}/bin/${name}";
    };
}
