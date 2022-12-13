{pkgs, ...}:
rec {
 makeElectronApp = { name, url }:
    pkgs.callPackage
      ({ pkgs
       , stdenv
       ,
       }:
        let
          electron = pkgs.electron_21;
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
            echo "${electron}/bin/electron --enable-features=UseOzonePlatform --ozone-platform=wayland --url=${url} $out/lib/${name}" >> $out/bin/${name}
            chmod +x $out/bin/${name}
          '';
        })
      { };

  makeWebApp =
    { name
    , desktopName
    , icon
    , url
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
      }}/bin/${name}";
    };
}
