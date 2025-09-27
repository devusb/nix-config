{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
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
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initContent = ''
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C vault vault
      setopt prompt_sp
      if [ -e ~/.env ]; then
      source ~/.env
      fi
      ${lib.getExe pkgs.nix-your-shell} zsh | source /dev/stdin
      bindkey "\e[1;3D" backward-word
      bindkey "\e[1;3C" forward-word
      bindkey "\e[1;5D" backward-word
      bindkey "\e[1;5C" forward-word
    ''
    + import ./extra/zsh_functions.nix { inherit pkgs; };
  };

  programs.keychain.enableZshIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.atuin.enableZshIntegration = true;
  programs.nix-index.enableZshIntegration = true;
  programs.eza.enableZshIntegration = true;

}
