{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-packages.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.system = "aarch64-darwin";

  system.primaryUser = "mhelton";

  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      accept-flake-config = false;
      trusted-users = [ "mhelton" ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
    };
    optimise.automatic = true;
  };

  users.knownUsers = [ "mhelton" ];
  users.users = {
    mhelton = {
      home = "/Users/mhelton";
      shell = pkgs.fish;
      uid = 501;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    colima
    docker
    wget
  ];

  services.tailscale.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "mhelton";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      upgrade = true;
      autoUpdate = false;
    };
    casks = [
      "rectangle"
      "firefox"
    ];
  };

  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      wvous-tl-corner = 2;
      wvous-br-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      tilesize = 57;
      show-recents = false;
      persistent-apps = [
        "/System/Applications/Apps.app"
        "/Applications/Firefox.app"
        "/System/Applications/Messages.app"
        "/System/Applications/FaceTime.app"
        "${pkgs.kitty}/Applications/kitty.app"
        "/System/Applications/System\ Settings.app"
      ];
    };
    trackpad = {
      Clicking = true;
      ActuationStrength = 1;
    };
    NSGlobalDomain = {
      "com.apple.trackpad.scaling" = 1.0;
      "NSAutomaticCapitalizationEnabled" = false;
      "NSAutomaticSpellingCorrectionEnabled" = false;
      "AppleInterfaceStyleSwitchesAutomatically" = true;
    };
    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      StandardHideWidgets = true;
    };
  };

}
