{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./kitty.nix
    ./ghostty.nix
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
    llm-agents.claude-code
    nchat
    gurk-rs
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
      ];
    })
    k9s
    kubectx
    talosctl
    lnav
    flox
    parallel
    dasel
    wolweb-cli
    llm-agents.agent-deck
    llm-agents.handy
    llm-agents.tuicr
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.nh = {
    enable = true;
    osFlake = "/dotfiles";
    darwinFlake = "${config.home.homeDirectory}/code/nix-config";
  };

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
    defaultEditor = true;
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
    settings = {
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      help = {
        autocorrect = "10";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options = {
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

  programs.ssh = {
    # default is below, suppresses warnings
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
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

  xdg.configFile."wolweb-cli.yaml".text = builtins.toJSON {
    server = "http://sophia:8089";
  };

}
