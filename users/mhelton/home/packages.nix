{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    k9s
    fluxcd
    vault
    kustomize
    kubernetes-helm
    speedtest-cli
    k3sup
    kompose
    mosh
    pwgen
    zip
    unzip
    awscli2
    sqlite
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
