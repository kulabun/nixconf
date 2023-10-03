{ config, lib, pkgs, user, ... }:
let
  inherit (import ./webapp { inherit pkgs; }) makeWebApp;

  google-calendar = makeWebApp {
    name = "google-calendar";
    desktopName = "Google Calendar";
    url = "https://calendar.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-calendar.png";
  };
  google-docs = makeWebApp {
    name = "google-docs";
    desktopName = "Google Docs";
    url = "https://docs.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-docs.png";
  };
  google-drive = makeWebApp {
    name = "google-drive";
    desktopName = "Google Drive";
    url = "https://drive.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-drive.png";
  };
  google-keep = makeWebApp {
    name = "google-keep";
    desktopName = "Google Keep";
    url = "https://keep.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/google-keep.png";
  };
  google-mail = makeWebApp {
    name = "google-mail";
    desktopName = "Google Mail";
    url = "https://mail.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/GMail-mail.google.com.png";
  };
  google-meet = makeWebApp {
    name = "google-meet";
    desktopName = "Google Meet";
    url = "https://meet.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/web-google-hangouts.png";
  };
  google-photos = makeWebApp {
    name = "google-photos";
    desktopName = "Google Photos";
    url = "https://photos.google.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/web-google-photos.png";
  };
  messenger = makeWebApp {
    name = "messenger";
    desktopName = "Messenger";
    url = "https://www.messenger.com";
    wmClass = "meta-webapps";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/fbmessenger.png";
  };
  telegram = makeWebApp {
    name = "telegram";
    desktopName = "Telegram";
    url = "https://web.telegram.org";
    wmClass = "telegram-webapps";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/telegram.png";
  };
  whatsapp = makeWebApp {
    name = "whatsapp";
    desktopName = "WhatsApp";
    url = "https://web.whatsapp.com";
    wmClass = "whatsapp-webapps";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/whatsapp.png";
  };
  poe = makeWebApp {
    name = "poe";
    desktopName = "POE";
    url = "https://poe.com";
    wmClass = "poe-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/categories/applications-science.png";
  };
  chatgpt = makeWebApp {
    name = "chatgpt";
    desktopName = "ChatGPT";
    url = "https://chat.openai.com/chat";
    wmClass = "chatgpt-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/categories/applications-science.png";
  };
  youtube-music = makeWebApp {
    name = "youtube-music";
    desktopName = "YouTube Music";
    url = "https://music.youtube.com";
    wmClass = "google-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/Youtube-youtube.com.png";
  };
  spotify = makeWebApp {
    name = "spotify";
    desktopName = "Spotify";
    url = "https://spotify.com";
    wmClass = "spotify-webapps";
    clearUserAgent = false;
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/Spotify.png";
  };
  mkEnableOpt = name: lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables ${name}.";
  };
in
with lib; {
  options = {
    programs'.webapps = {
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
      poe.enable = mkEnableOpt "poe";
      chatgpt.enable = mkEnableOpt "chatgpt";
      youtube-music.enable = mkEnableOpt "youtube-music";
      spotify.enable = mkEnableOpt "youtube-music";
    };
  };

  config = {
    home-manager.users.${user} = {
      home.packages =
        [ ]
        ++ optional config.programs'.webapps.google-calendar.enable google-calendar
        ++ optional config.programs'.webapps.google-docs.enable google-docs
        ++ optional config.programs'.webapps.google-drive.enable google-drive
        ++ optional config.programs'.webapps.google-keep.enable google-keep
        ++ optional config.programs'.webapps.google-mail.enable google-mail
        ++ optional config.programs'.webapps.google-meet.enable google-meet
        ++ optional config.programs'.webapps.google-photos.enable google-photos
        ++ optional config.programs'.webapps.messenger.enable messenger
        ++ optional config.programs'.webapps.telegram.enable telegram
        ++ optional config.programs'.webapps.whatsapp.enable whatsapp
        ++ optional config.programs'.webapps.poe.enable poe
        ++ optional config.programs'.webapps.chatgpt.enable chatgpt
        ++ optional config.programs'.webapps.youtube-music.enable youtube-music
        ++ optional config.programs'.webapps.spotify.enable spotify;
    };
  };
}
