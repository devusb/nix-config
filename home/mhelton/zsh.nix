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
    initContent =
      ''
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
      ''
      + import ./extra/zsh_functions.nix { inherit pkgs; };
  };
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.keychain.overrideAttrs (old: rec {
      version = "2.8.5";

      src = old.src.override {
        rev = version;
        sha256 = "sha256-sg6Um0nsK/IFlsIt2ocmNO8ZeQ6RnXE5lG0tocCjcq4=";
      };
    });
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
      sync.records = true;
      style = "auto";
      inline_height = 0;
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
