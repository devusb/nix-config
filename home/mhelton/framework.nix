{ ... }: {
  programs.plasma.window-rules = [
    {
      description = "Firefox HiDPI Initial Size";
      match = {
        window-class = {
          value = "firefox";
          type = "exact";
          match-whole = false;
        };
        title = {
          value = "Mozilla Firefox";
          type = "exact";
        };
        window-types = [ "normal" ];
      };
      apply = {
        size = {
          value = "1682,1084";
        };
      };
    }
  ];

}
