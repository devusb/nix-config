{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
  ] ++ (builtins.attrValues outputs.darwinModules);

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      user = "root";
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    wget
    nano
  ];

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
}
