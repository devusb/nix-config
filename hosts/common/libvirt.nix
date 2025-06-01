{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    sshProxy = false;
    qemu.swtpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  programs.ssh.systemd-ssh-proxy.enable = false;
}
