{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    vault
    speedtest-go
    pwgen
    zip
    unzip
    awscli2
    yq-go
    tldr
    terraform
    unrar
    zsh-nix-shell
    nerd-fonts.fira-code
    nil
    headsetcontrol
    difftastic
    devenv
    ouch
    attic-client
    fx
    go-plex-client
    ripgrep-all
    nix-output-monitor
    tv-sony
    soco-cli
    fastfetch
    tig
    git-absorb
    delta
    kubectl
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
      ];
    })
    k9s
    kubectx
    argocd
    talosctl
    lnav
    flox
    parallel
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
  }
  // import ./nixvim.nix { inherit pkgs; };

  programs.bat = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.lesspipe.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  programs.git = {
    enable = true;
    extraConfig = {
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      help = {
        autocorrect = "10";
      };
    };
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };
  };

  programs.fd = {
    enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
    };
  };

}
