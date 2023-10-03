{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.work'.firefox;
in
{
  options.work'.firefox.enable = mkEnableOption "Firefox Work Configuration";

  config = mkIf cfg.enable {
    programs'.firefox.enable = true;

    home-manager.users.${user} = {
      programs.firefox = {
        profiles = {
          default = {
            settings = {
              # "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
              # "browser.startup.homepage" = "https://id.indeed.tech";
              "extensions.activeThemeID" = "default-theme@mozilla.org";
            };


            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              grammarly
              okta-browser-plugin
              # zoom - missing in rycee repo, should be installed manually
            ];

            bookmarks = {
              "indeed-blog" = {
                name = "Indeed - Eng Blog";
                keyword = "!blog";
                url = "https://wiki.indeed.com/pages/viewrecentblogposts.action?key=eng";
              };
              "indeed-apps" = {
                name = "Indeed - Apps";
                keyword = "!apps";
                url = "https://id.indeed.tech";
              };
              "indeed-jira" = {
                name = "Indeed - Jira";
                keyword = "!jira";
                url = "https://bugs.indeed.com";
              };
              "indeed-jira-kanban-board" = {
                name = "Indeed - Jira - Kanban Board";
                keyword = "!kanban";
                url = "https://bugs.indeed.com/secure/RapidBoard.jspa?rapidView=13137";
              };
              "indeed-gitlab-team-merge-requests" = {
                name = "Indeed - Gitlab - Team Merge Requests";
                keyword = "!mrs";
                url = "https://code.corp.indeed.com/groups/profile-io/-/merge_requests";
              };
              "indeed-datadog" = {
                name = "Indeed - DataDog - APM";
                keyword = "!dd";
                url = "https://app.datadoghq.com/apm/home";
              };
            };

            search.engines = {
              "DataDog Dashboards" = {
                urls = [{ template = "https://app.datadoghq.com/dashboard/lists?q={searchTerms}"; }];
                iconUpdateURL = "https://datadog.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@ddd" ];
              };

              "DataDog APM" = {
                urls = [{ template = "https://app.datadoghq.com/apm/home?search={searchTerms}&env=prod"; }];
                iconUpdateURL = "https://datadog.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@dda" ];
              };

              "Indeed Jira" = {
                urls = [{ template = "https://bugs.indeed.com/secure/QuickSearch.jspa?searchString={searchTerms}"; }];
                iconUpdateURL = "https://bugs.indeed.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@ij" ];
              };

              "Indeed Wiki" = {
                urls = [{ template = "https://wiki.indeed.com/dosearchsite.action?cql=siteSearch+~+%22{searchTerms}%22"; }];
                iconUpdateURL = "https://wiki.indeed.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@iw" ];
              };

              "Indeed CloudSearch" = {
                urls = [{ template = "https://cloudsearch.google.com/cloudsearch/search?q={searchTerms}"; }];
                iconUpdateURL = "https://ssl.gstatic.com/social/topazui/images/favicons/16X16.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@is" ];
              };

              "Indeed Sourcegraph" = {
                urls = [{ template = "https://indeed.sourcegraph.com/search?q={searchTerms}"; }];
                iconUpdateURL = "https://indeed.sourcegraph.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@isg" ];
              };

              "Indeed Gitlab" = {
                urls = [{ template = "https://code.corp.indeed.com/search?search={searchTerms}"; }];
                iconUpdateURL = "https://code.corp.indeed.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@ig" ];
              };
            };
          };
        };
      };
    };
  };
}
