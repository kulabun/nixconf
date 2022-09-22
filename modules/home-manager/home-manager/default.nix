{ config, pgks, ... }: {
  programs = { home-manager.enable = true; };

  manual = {
    html.enable = true;
    json.enable = true;
  };
}

