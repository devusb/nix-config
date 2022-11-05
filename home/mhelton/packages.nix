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
    (pkgs.ansible_2_13.override { windowsSupport = true; })
    terraform
    colmena
    unrar
    zsh-nix-shell
    mach-nix
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.home-manager = {
    enable = true;
  };

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
          { Ctrl = "s"; }
        ];
        session = [
          { action = [ "Quit" ]; key = [{ Char = "q"; }]; }
          { action = [{ SwitchToMode = "Search"; }]; key = [{ Char = "s"; }]; }
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
