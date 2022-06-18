{ pkgs, ...}: {
  home.packages = with pkgs; [ 
    kubectl 
    kubectx 
    k9s
    fluxcd
    vault
    kustomize
    kubernetes-helm
    speedtest-cli
    htop
    k3sup
    kompose
    micro
    mosh
    pwgen
    inetutils
    zip
    unzip
    awscli2
    jq
    sqlite
    screen
    yq-go
    tldr
    ripgrep
    bat
    exa
    ansible
    terraform
    colmena
    unrar
    zsh-nix-shell
    mach-nix
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
