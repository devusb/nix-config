{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-packages.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.system = "aarch64-darwin";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
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

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
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
    ];
  };

  services.nix-daemon.enable = true;

  programs.zsh.enable = true; # default shell on catalina

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
    };
    trackpad = {
      Clicking = true;
      ActuationStrength = 1;
    };
    NSGlobalDomain = {
      "com.apple.trackpad.scaling" = 1.0;
      "NSAutomaticCapitalizationEnabled" = false;
      "NSAutomaticSpellingCorrectionEnabled" = false;
    };
  };

  system.activationScripts.postActivation.text = ''
    dscl . -create '/Users/${builtins.elemAt (builtins.attrNames config.users.users) 0}' UserShell '${pkgs.zsh}/bin/zsh'
  '';
}
