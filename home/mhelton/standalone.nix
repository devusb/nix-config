{ pkgs, ... }:
let
  ryujinx-wrapped = pkgs.writeShellApplication {
    name = "ryujinx";
    runtimeInputs = with pkgs; [ ryujinx nixgl.nixVulkanIntel ];
    text = ''
      nixVulkanIntel ryujinx
    '';
  };
in
{
  home.packages = with pkgs; [
    nix
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel
    ryujinx-wrapped
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    extra-experimental-features = "nix-command flakes";
  };

  programs.keychain.enable = pkgs.lib.mkForce false;

  home.sessionVariables = {
    DOTFILES = "$HOME/code/nix-config/";
  };

  services.syncthing.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        user = "mhelton";
      };
    };
  };

}
