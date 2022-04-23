{ pkgs, inputs, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/aarch64-vm.nix
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "21.11"; 

  # enable syslog
  services.syslogd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  networking.useDHCP = false;
  networking.interfaces.enp0s10.useDHCP = true;
  networking.firewall.enable = false;

  # testing sops
  sops.defaultSopsFile = ../../secrets/home/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.id_rsa = {
    group = config.users.groups.keys.name;
    mode = "0440";
  };
  sops.secrets.id_ed25519 = {
    group = config.users.groups.keys.name;
    mode = "0440";
  };

}
