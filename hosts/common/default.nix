{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nur.nixosModules.nur
  ];

  # Set your time zone.
  time.timeZone = "US/Central";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nfs-utils
    psmisc
  ];

  services.tailscale = {
    enable = true;
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # enable passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable flakes and new 'nix' command
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
  };

  # This will make all users activate their home-manager profile upon login, if
  # it exists and is not activated yet. This is useful for setups with opt-in
  # persistance, avoiding having to manually activate every reboot.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';

  # This will add your inputs as registries, making operations with them
  # consistent with your flake inputs.
  nix.registry = lib.mapAttrs'
    (n: v:
      lib.nameValuePair (n) ({ flake = v; })
    )
    inputs;

  # install some programs globally
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
