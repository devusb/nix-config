# Add your NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).

{
  nqptp = ./nqptp.nix;
  shairport-sync = ./shairport-sync.nix;
  sunshine = ./sunshine.nix;
  sleep-on-lan = ./sleep-on-lan.nix;
  plex-mpv-shim = ./plex-mpv-shim.nix;
  nfs-client = ./nfs-client.nix;
  chiaki4deck = ./chiaki4deck.nix;
  flatpak-update = ./flatpak-update.nix;
  deckbd = ./deckbd.nix;
}
