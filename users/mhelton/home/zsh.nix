{ pkgs, config, system, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    shellAliases = {
      ll = "${pkgs.exa}/bin/exa -l --git --icons";
      ls = "${pkgs.exa}/bin/exa --icons";
      lla = "${pkgs.exa}/bin/exa -la --git --icons";
      lt = "${pkgs.exa}/bin/exa --tree --icons";
      la = "${pkgs.exa}/bin/exa -a --icons";
      ga-intent = "${pkgs.git}/bin/git add --intent-to-add";
      grm-cache = "${pkgs.git}/bin/git rm --cached";
      update = if system == "aarch64-darwin" then "darwin-rebuild switch --flake $DOTFILES && rm result" else "nixos-rebuild switch --use-remote-sudo --flake $DOTFILES";
      update-home = "home-manager switch --flake $DOTFILES";
      kb = "${pkgs.kubectl}/bin/kubectl";
      cat = "${pkgs.bat}/bin/bat --paging=always";
      ts = "tailscale";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    completionInit = ''
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C vault vault
    '';
    initExtra = ''
      if [ -e ~/.env ]; then
      source ~/.env
      fi
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
    '' + builtins.readFile ./extra/functions.zsh
    ;
  };
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      gcloud.disabled = true;
      shlvl.disabled = false;
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      sync_address = "https://atuin.gaia.devusb.us";
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fulltext";
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
