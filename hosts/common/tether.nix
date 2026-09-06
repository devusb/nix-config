{ inputs, ... }:
{
  imports = [
    inputs.tether.nixosModules.tether
  ];

  programs.tether = {
    enable = true;
    wifi = {
      enable = true;
      openFirewall = true;
    };
    bluetooth.enable = true;
  };
}
