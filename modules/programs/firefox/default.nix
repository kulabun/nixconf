{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.firefox;
in
{
  options.programs'.firefox.enable = mkEnableOption "Firefox";

  config = mkIf cfg.enable {
    # Enable wayland support for firefox
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
    };

    home-manager.users.${user} = {
      home.packages = [
        # (pkgs.makeDesktopItem {
        #   icon = "firefox";
        #   name = "Indeed Firefox";
        #   genericName = "Browser";
        #   desktopName = "Indeed Firefox";
        #   startupWMClass = "firefox";
        #   exec = "firefox -P work";
        # })
      ];
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;

        profiles = {
          default = {
            isDefault = true;
            userChrome = builtins.readFile ./config/userChrome.css;
            id = 0;

            settings = {
              "extensions.pocket.enabled" = false;
              "gfx.webrender.all" = true;
              "browser.quitShortcut.disabled" = true;
              "browser.toolbars.bookmarks.visibility" = "never";
              "browser.onboarding.enabled" = false;

              # Enable Hardware acceleration
              "media.ffmpeg.vaapi.enabled" = true;
              "media.ffvpx.enabled" = false;
              "media.navigator.mediadatadecoder_vpx_enabled" = true;
              "media.rdd-vpx.enabled" = false;

              # Enable custom CSS for Firefox UI
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

              # HTTPS
              "dom.security.https_only_mode" = true; # HTTPS everywhere
              "dom.security.https_only_mode_ever_enabled" = true;

              # New tab page.
              "browser.newtabpage.activity-stream.feeds.section.highlights" = false; # Recent activity.
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Pocket.
              "browser.newtabpage.activity-stream.feeds.topsites" = false; # Shortcuts.
              "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
              "browser.newtabpage.activity-stream.showSearch" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.enabled" = false;

              # Clean up search bar.
              "browser.search.hiddenOneOffs" = "Amazon.com,Bing,DuckDuckGo,eBay,Google,Wikipedia (en)";
              "browser.search.suggest.enabled" = false;
              "browser.urlbar.shortcuts.bookmarks" = true;
              "browser.urlbar.shortcuts.history" = false;
              "browser.urlbar.shortcuts.tabs" = false;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
              "browser.urlbar.suggest.bookmark" = false;
              "browser.urlbar.suggest.engines" = false;
              "browser.urlbar.suggest.history" = false;
              "browser.urlbar.suggest.openpage" = false;
              "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.suggest.topsites" = false;

              ################ Privacy ########################
              # No autofill
              "signon.autofillForms" = false;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "browser.formfill.enable" = false;

              "privacy.donottrackheader.enabled" = true;
              "privacy.history.custom" = true;
              "privacy.trackingprotection.cryptomining.enabled" = true;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;

              "app.shield.optoutstudies.enabled" = false;
              "browser.contentblocking.category" = "standard";
              "browser.contentblocking.cryptomining.preferences.ui.enabled" = true;
              "browser.contentblocking.fingerprinting.preferences.ui.enabled" = true;
              "browser.discovery.enabled" = false;
              "network.cookie.cookieBehavior" = 5;
              "places.history.enabled" = false;
              "signon.generation.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
              "signon.rememberSignons" = false;

              # No telemetry
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.pioneer-new-studies-available" = false;
              "toolkit.telemetry.reportingpolicy.firstRun" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "security.app_menu.recordEventTelemetry" = false;
              "security.certerrors.recordEventTelemetry" = false;
              "security.identitypopup.recordEventTelemetry" = false;
              "security.protectionspopup.recordEventTelemetry" = false;
              "browser.ping-centre.telemetry" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;

              # Firefox Sync
              "services.sync.declinedEngines" = "passwords,creditcards";
            };


            search.engines = {
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
              "Amazon.com".metaData.hidden = true;
              "Wikipedia (en)".metaData.hidden = true;
              "DuckDuckGo".metaData.alias = "@ddg";
              "Google".metaData.alias = "@g";

              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "Sourcegraph" = {
                urls = [{ template = "https://sourcegraph.com/search?q={searchTerms}"; }];
                iconUpdateURL = "https://sourcegraph.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@sg" ];
              };

              "GitHub" = {
                urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@gh" ];
              };

              "Google Docs" = {
                urls = [{ template = "https://docs.google.com/document/u/0/?q={searchTerms}"; }];
                iconUpdateURL = "https://ssl.gstatic.com/docs/documents/images/kix-favicon7.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@docs" ];
              };

              "Google Sheets" = {
                urls = [{ template = "https://sheets.google.com/document/u/0/?q={searchTerms}"; }];
                iconUpdateURL = "https://ssl.gstatic.com/docs/spreadsheets/favicon3.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@sheets" ];
              };

              "Google Drive" = {
                urls = [{ template = "https://drive.google.com/drive/search?q={searchTerms}"; }];
                iconUpdateURL = "https://ssl.gstatic.com/images/branding/product/1x/drive_2020q4_48dp.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@drive" ];
              };
            };

            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              bitwarden
              multi-account-containers
              privacy-badger
              tree-style-tab
              firefox-translations
              ublock-origin
              vimium
              facebook-container

              languagetool
              # zoom-redirector
              redirector

              # greasemonkey
            ];

            bookmarks = {
              "google-docs" = { name = "Google Docs"; keyword = "!docs"; url = "https://docs.google.com"; };
              "google-sheets" = { name = "Google Sheets"; keyword = "!sheets"; url = "https://sheets.google.com"; };
              "google-meet" = { name = "Google Meet"; keyword = "!meet"; url = "https://meet.google.com"; };
            };
          };
        };
      };
    };
  };
}
