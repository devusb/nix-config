{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
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
    lfs.enable = true;
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
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
    };
  };

  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "2m";
    };
    nix-direnv = {
      enable = true;
    };
  };

  programs.keychain = {
    enable = true;
    package = pkgs.keychain.overrideAttrs (old: rec {
      version = "2.8.5";

      src = old.src.override {
        rev = version;
        sha256 = "sha256-sg6Um0nsK/IFlsIt2ocmNO8ZeQ6RnXE5lG0tocCjcq4=";
      };
    });
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      gcloud.disabled = true;
      shlvl.disabled = false;
      command_timeout = 5000;
      kubernetes.contexts = [
        {
          context_pattern = "gke_.*_(?P<var_cluster>[\\w-]+)";
          context_alias = "gke-$var_cluster";
        }
        {
          context_pattern = "arn:.*/(?P<var_cluster>[\\w-]+)";
          context_alias = "aws-$var_cluster";
        }
      ];
      env_var = {
        DATABASE_URI = {
          style = "yellow bold";
          format = "with [$symbol$env_value]($style) ";
          symbol = "⛁ ";
        };
      };
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      sync_address = "https://atuin.springhare-egret.ts.net";
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fulltext";
      sync.records = true;
      style = "auto";
      inline_height = 0;
      update_check = false;
    };
  };

}
