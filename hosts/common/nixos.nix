{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nur.nixosModules.nur
    ./nix.nix
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

  # This will make all users activate their home-manager profile upon login, if
  # it exists and is not activated yet. This is useful for setups with opt-in
  # persistance, avoiding having to manually activate every reboot.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';

  # install some programs globally
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
