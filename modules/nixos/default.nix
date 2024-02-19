# Add your NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).

{
  nfs-client = ./nfs-client.nix;
  flatpak-update = ./flatpak-update.nix;
}
