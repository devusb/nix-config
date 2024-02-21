{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-packages.darwinModules.default
  ] ++ (builtins.attrValues outputs.darwinModules);

  nixpkgs.system = "aarch64-darwin";

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = false;
      warn-dirty = false;
      trusted-users = [ "mhelton" ];
    };

    gc = {
      automatic = true;
      user = "root";
      options = "--delete-older-than 14d";
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  environment.systemPackages = with pkgs; [
    neovim
    colima
    docker
    wget
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

  system.activationScripts.postActivation.text = ''
    dscl . -create '/Users/${builtins.elemAt (builtins.attrNames config.users.users) 0}' UserShell '${pkgs.zsh}/bin/zsh'
  '';
}
