{ config, pkgs, lib, ... }: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "swaylock";
      }
      {
        event = "before-sleep";
        command = "playerctl pause";
      }
      {
        event = "before-sleep";
        command = "swaylock";
      }
      {
        event = "after-resume";
        command = "swaymsg 'output * dpms on'";
      }
      {
        event = "after-resume";
        # gdm runs on tt7, while sway on different one. after wake up gdm appear ahead of swaylock, I dont want that
        command = ''
          w | egrep tty[1-9] | sed "s/.* tty([1-9]) .*/1/g" | xargs sudo chvt'';
      }
    ];

    timeouts = [
      {
        timeout = 600;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
      {
        timeout = 605;
        command = "swaylock";
      }
    ];
  };
}
