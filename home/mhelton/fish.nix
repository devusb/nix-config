{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = import ./extra/aliases.nix { inherit pkgs lib; };
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
    '';
    functions = {
      nr = import ./extra/fish/nr.nix { inherit pkgs lib; };
      ns = import ./extra/fish/ns.nix { inherit pkgs lib; };
    };
  };

  programs.keychain.enableFishIntegration = true;
  programs.starship.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.atuin.enableFishIntegration = true;
  programs.nix-index.enableFishIntegration = true;
  programs.eza.enableFishIntegration = true;

}
