{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
let
  makeElectronApp = { name, url }:
    pkgs'.callPackage
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

  google-calendar = makeWebApp {
    name = "google-calendar";
    desktopName = "Google Calendar";
    url = "https://calendar.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-calendar.png";
  };
  google-docs = makeWebApp {
    name = "google-docs";
    desktopName = "Google Docs";
    url = "https://docs.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-docs.png";
  };
  google-drive = makeWebApp {
    name = "google-drive";
    desktopName = "Google Drive";
    url = "https://drive.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-drive.png";
  };
  google-keep = makeWebApp {
    name = "google-keep";
    desktopName = "Google Keep";
    url = "https://keep.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-keep.png";
  };
  google-mail = makeWebApp {
    name = "google-mail";
    desktopName = "Google Mail";
    url = "https://mail.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/GMail-mail.google.com.png";
  };
  google-meet = makeWebApp {
    name = "google-meet";
    desktopName = "Google Meet";
    url = "https://meet.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/web-google-hangouts.png";
  };
  google-photos = makeWebApp {
    name = "google-photos";
    desktopName = "Google Photos";
    url = "https://photos.google.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/web-google-photos.png";
  };
  messenger = makeWebApp {
    name = "messenger";
    desktopName = "Messenger";
    url = "https://www.messenger.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/messenger.png";
  };
  telegram = makeWebApp {
    name = "telegram";
    desktopName = "Telegram";
    url = "https://web.telegram.org";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/telegram.png";
  };
  whatsapp = makeWebApp {
    name = "whatsapp";
    desktopName = "WhatsApp";
    url = "https://web.whatsapp.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/whatsapp.png";
  };
  youtube-music = makeWebApp {
    name = "youtube-music";
    desktopName = "YouTube Music";
    url = "https://music.youtube.com";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/Youtube-youtube.com.png";
  };
in
with lib;
with mylib; {
  options = {
    settings.webapps = {
      google-calendar.enable = mkEnableOpt "google-calendar";
      google-docs.enable = mkEnableOpt "google-docs";
      google-drive.enable = mkEnableOpt "google-drive";
      google-keep.enable = mkEnableOpt "google-keep";
      google-mail.enable = mkEnableOpt "google-mail";
      google-meet.enable = mkEnableOpt "google-meet";
      google-photos.enable = mkEnableOpt "google-photos";
      messenger.enable = mkEnableOpt "messenger";
      telegram.enable = mkEnableOpt "telegram";
      whatsapp.enable = mkEnableOpt "whatsapp";
      youtube-music.enable = mkEnableOpt "youtube-music";
    };
  };

  config = {
    home.packages =
      [ ]
      ++ optional config.settings.webapps.google-calendar.enable google-calendar
      ++ optional config.settings.webapps.google-docs.enable google-docs
      ++ optional config.settings.webapps.google-drive.enable google-drive
      ++ optional config.settings.webapps.google-keep.enable google-keep
      ++ optional config.settings.webapps.google-mail.enable google-mail
      ++ optional config.settings.webapps.google-meet.enable google-meet
      ++ optional config.settings.webapps.google-photos.enable google-photos
      ++ optional config.settings.webapps.messenger.enable messenger
      ++ optional config.settings.webapps.telegram.enable telegram
      ++ optional config.settings.webapps.whatsapp.enable whatsapp
      ++ optional config.settings.webapps.youtube-music.enable youtube-music;
  };
}