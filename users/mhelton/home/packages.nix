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
    inetutils
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
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.bat = {
    enable = true;
  };

  programs.exa = {
    enable = true;
  };

  programs.micro = {
    enable = true;
    settings = {
      softwrap = true;
    };
  };
  xdg.configFile."micro/syntax/terraform.yaml".source =
    pkgs.fetchFromGitHub
      {
        owner = "devusb";
        repo = "micro-terraform-syntax";
        rev = "master";
        sha256 = "sha256-2R6Lo4ZvglNMzfkjDYqt19Az2oBSsth6WhHZtiVylx4=";
      } + "/terraform.micro";

  programs.jq = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };
}
