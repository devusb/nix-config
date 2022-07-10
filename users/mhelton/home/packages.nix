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
    screen
    yq-go
    tldr
    ripgrep
    ansible
    terraform
    colmena
    unrar
    zsh-nix-shell
    mach-nix
    tailscale
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
}
