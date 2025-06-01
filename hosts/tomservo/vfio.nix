{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-vfio.nixosModules.vfio
    ../common/libvirt.nix
  ];

  virtualisation.libvirtd = {
    deviceACL = [
      "/dev/kvm"
      "/dev/kvmfr0"
      "/dev/kvmfr1"
      "/dev/kvmfr2"
      "/dev/shm/scream"
      "/dev/shm/looking-glass"
      "/dev/null"
      "/dev/full"
      "/dev/zero"
      "/dev/random"
      "/dev/urandom"
      "/dev/ptmx"
      "/dev/kvm"
      "/dev/kqemu"
      "/dev/rtc"
      "/dev/hpet"
      "/dev/vfio/vfio"
    ];
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
      "1002:1478"
      "1002:1479"
      "1002:744c"
      "1002:ab30"
    ];
  };

  virtualisation.kvmfr = {
    enable = true;
    devices = lib.singleton {
      size = 128;
      permissions = {
        user = "mhelton";
        mode = "0777";
      };
    };
  };
  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  boot.blacklistedKernelModules = [
    "amdgpu"
    "radeon"
  ];

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

}
