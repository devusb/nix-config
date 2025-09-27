{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ga-intent = "${lib.getExe pkgs.git} add --intent-to-add";
      grm-cache = "${lib.getExe pkgs.git} rm --cached";
      update =
        if pkgs.stdenv.isDarwin then
          "darwin-rebuild switch --flake $DOTFILES"
        else
          "nixos-rebuild switch --sudo --flake $DOTFILES";
      update-boot = lib.mkIf pkgs.stdenv.isLinux "nixos-rebuild boot --sudo --flake $DOTFILES";
      update-test = lib.mkIf pkgs.stdenv.isLinux "nixos-rebuild test --sudo --flake $DOTFILES";
      kb = "${lib.getExe pkgs.kubectl}";
      cat = "${lib.getExe pkgs.bat} --paging=always";
      ts = "${lib.getExe pkgs.tailscale}";
      gl = "${lib.getExe pkgs.git} log -p --ext-diff";
      watch = "${lib.getExe pkgs.watch} --color ";
      t = "${lib.getExe pkgs.tmux}";
      ta = "${lib.getExe pkgs.tmux} attach";
    };
    interactiveShellInit = ''
      set fish_greeting
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
