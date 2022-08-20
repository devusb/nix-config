{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    k9s
    fluxcd
    vault
    kubernetes-helm
    speedtest-cli
    pwgen
    zip
    unzip
    awscli2
    yq-go
    tldr
    ripgrep
    ansible
    terraform
    colmena
    unrar
    zsh-nix-shell
    mach-nix
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.bat = {
    enable = true;
  };

  programs.exa = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      keybinds = {
        unbind = [
          { Ctrl = "q"; }
        ];
        session = [
          { action = [ "Quit" ]; key = [{ Char = "q"; }]; }
        ];
      };
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      push = {
        default = "simple";
      };
      help = {
        autocorrect = "10";
      };
    };
  };
}
