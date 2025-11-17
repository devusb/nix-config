{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-packages.nixosModules.default
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      accept-flake-config = false;
      trusted-users = [ "mhelton" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
        "https://colmena.cachix.org"
        "https://attic.springhare-egret.ts.net/r2d2"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "r2d2:dGjwZKsBup19Wq8b3/W2smJjrw55tC0DnCQhu/qsfb4="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    channel.enable = false;
  };

  # Set your time zone.
  services.automatic-timezoned.enable = lib.mkDefault false;

  services.fstrim.enable = true;
  boot.swraid.enable = lib.mkDefault false;

  services.earlyoom = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    curl
    wget
    git
    nfs-utils
    psmisc
    bottom
    htop
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  programs.librepods.enable = true;

  services.udev.extraRules =
    let
      # swap rudder and throttle order for Wing Commander 3 (and potentially others)
      remapJoystickAxes = pkgs.writeShellScriptBin "remap-axes.sh" ''
        ${lib.getExe' pkgs.linuxConsoleTools "jscal"} -u 6,0,1,6,5,16,17,12,288,289,290,291,292,293,294,295,296,297,298,299 $1
        ${lib.getExe' pkgs.linuxConsoleTools "jscal"} -s 6,1,0,448,574,1394427,1394427,1,0,448,574,1394427,1394427,1,0,112,142,5534582,5534582,1,0,112,142,-5534582,-5534582,1,0,0,0,536854528,536854528,1,0,0,0,536854528,536854528 $1
      '';
    in
    ''
      # Logitech G533
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0a66", TAG+="uaccess"

      # Logitech Extreme 3D pro
      ACTION=="add", KERNEL=="js[0-9]*", ENV{ID_VENDOR_ID}=="046d", ENV{ID_MODEL_ID}=="c215", RUN+="${lib.getExe remapJoystickAxes} /dev/input/js%n"
    '';

  # keychron function keys
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
    settings = {
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # enable passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # This will make all users activate their home-manager profile upon login, if
  # it exists and is not activated yet. This is useful for setups with opt-in
  # persistance, avoiding having to manually activate every reboot.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';

  # install some programs globally
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

}
