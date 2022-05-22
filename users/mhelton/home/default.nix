{ inputs, lib, config, pkgs, hostname, graphical, gaming, system, work, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    ./zsh.nix
    #"${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256="1cszfjwshj6imkwip270ln4l1j328aw2zh9vm26wv3asnqlhdrak";}}/modules/vscode-server/home.nix"
  ]
  ++ (if graphical == true then [ ./graphical.nix ] else [])
  ++ (if gaming == true then [ ./gaming.nix ] else [])
  ++ (if system == "aarch64-linux" then [./aarch64.nix] else [])
  ++ (if work == true then [./work.nix] else [./personal.nix]);

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Install packages
  home.packages = with pkgs; [ 
    kubectl 
    kubectx 
    k9s
    fluxcd
    vault
    kustomize
    kubernetes-helm
    #ansible
    speedtest-cli
    htop
    k3sup
    kompose
    micro
    mosh
    pwgen
    #python3
    inetutils
    zip
    unzip
    awscli2
    #dig
    jq
    #yq
    sqlite
    screen
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Enable vscode-server support
  #services.vscode-server.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  
}
