{ pkgs, lib, config, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      ga-intent = "${pkgs.git}/bin/git add --intent-to-add";
      grm-cache = "${pkgs.git}/bin/git rm --cached";
      update = if pkgs.stdenv.isDarwin then "darwin-rebuild switch --flake $DOTFILES" else "nixos-rebuild switch --use-remote-sudo --flake $DOTFILES";
      update-boot = lib.mkIf pkgs.stdenv.isLinux "nixos-rebuild boot --use-remote-sudo --flake $DOTFILES";
      kb = "${pkgs.kubectl}/bin/kubectl";
      cat = "${pkgs.bat}/bin/bat --paging=always";
      ts = "${pkgs.tailscale}/bin/tailscale";
      za = "${pkgs.zellij}/bin/zellij attach";
      zr = "${pkgs.zellij}/bin/zellij run";
      ze = "${pkgs.zellij}/bin/zellij edit";
      z = "${pkgs.zellij}/bin/zellij";
      gl = "${pkgs.git}/bin/git log -p --ext-diff";
      watch = "${lib.getExe pkgs.watch} --color ";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C vault vault
      setopt prompt_sp
      if [ -e ~/.env ]; then
      source ~/.env
      fi
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      bindkey "\e[1;3D" backward-word
      bindkey "\e[1;3C" forward-word
      bindkey "\e[1;5D" backward-word
      bindkey "\e[1;5C" forward-word
    '' + import ./extra/zsh_functions.nix { inherit pkgs; };
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
      command_timeout = 5000;
      kubernetes.contexts = [
        {
          context_pattern = "gke_.*_(?P<var_cluster>[\\w-]+)";
          context_alias = "gke-$var_cluster";
        }
        {
          context_pattern = "arn:.*/(?P<var_cluster>[\\w-]+)";
          context_alias = "aws-$var_cluster";
        }
      ];
      env_var = {
        DATABASE_URI = {
          style = "yellow bold";
          format = "with [$symbol$env_value]($style) ";
          symbol = "⛁ ";
        };
      };
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
      sync_address = "https://atuin.springhare-egret.ts.net";
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fulltext";
    };
  };
  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "2m";
    };
    nix-direnv = {
      enable = true;
    };
  };
}
