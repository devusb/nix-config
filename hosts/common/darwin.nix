{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.nix-packages.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.system = "aarch64-darwin";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = false;
      warn-dirty = false;
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
  };

  users.users = {
    mhelton = {
      home = "/Users/mhelton";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    colima
    docker
    wget
  ];

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
      "obsidian"
      "mimestream"
      "rectangle"
      "firefox"
      "aldente"
      "deskpad"
    ];
  };

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true; # enable TouchID for sudo

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
        "/System/Applications/Launchpad.app"
        "/Applications/Firefox.app"
        "/System/Applications/Messages.app"
        "/System/Applications/FaceTime.app"
        "/Applications/Mimestream.app"
        "${pkgs.kitty}/Applications/kitty.app"
        "/Applications/Obsidian.app"
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
  };

  system.activationScripts.postActivation.text = ''
    dscl . -create '/Users/${builtins.elemAt (builtins.attrNames config.users.users) 0}' UserShell '${pkgs.zsh}/bin/zsh'
  '';
}
