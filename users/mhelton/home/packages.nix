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
    python3
    inetutils
    zip
    unzip
    awscli2
    jq
    sqlite
    screen
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}