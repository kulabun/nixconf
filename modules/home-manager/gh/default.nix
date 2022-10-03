{
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.gh.enable = mkEnableOpt "gh";
  };

  config = mkIf config.settings.gh.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = true;
        aliases = {
          rcr = "repo create";
          rfk = "repo fork --clone --remote";
          rv = "repo view";
          rvw = "repo view --web";
          icl = "issue close";
          icr = "issue create";
          il = "issue list";
          ire = "issue reopen";
          iv = "issue view";
          ivw = "issue view --web";
          pco = "pr checkout";
          pck = "pr checks";
          pcl = "pr close";
          pcr = "pr create";
          pd = "pr diff";
          pl = "pr list";
          pm = "pr merge";
          pre = "pr reopen";
          pv = "pr view";
          pvw = "pr view --web";
        };
      };
    };
  };
}
