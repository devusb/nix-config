{ inputs, pkgs, ... }: {
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
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nil
    nixpkgs-fmt
    headsetcontrol
    difftastic
    devenv'
    ouch
    attic-client
    fx
    go-plex-client
    ripgrep-all
    nix-output-monitor
    tv-sony
    soco-cli
    iodine
    fastfetch
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
  } // import ./nixvim.nix { inherit pkgs; };

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
    icons = true;
    git = true;
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
          "Ctrl q"
        ];
        session = {
          "bind \"q\"" = {
            Quit = [ ];
          };
        };
      };
    };
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

}
