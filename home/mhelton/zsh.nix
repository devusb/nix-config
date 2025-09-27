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
    shellAliases = import ./extra/aliases.nix { inherit pkgs lib; };
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
