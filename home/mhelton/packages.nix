{ pkgs, ... }: {
  imports = [
    ./micro.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    vault
    speedtest-cli
    pwgen
    zip
    unzip
    awscli2
    yq-go
    tldr
    ripgrep
    terraform
    unrar
    zsh-nix-shell
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nil
    nixpkgs-fmt
    headsetcontrol
    difftastic
    devenv
    nix-search
  ];

  programs.home-manager = {
    enable = true;
  };

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
    settings = {
      keybinds = {
        unbind = [
          { Ctrl = "q"; }
          { Ctrl = "s"; }
        ];
        session = [
          { action = [ "Quit" ]; key = [{ Char = "q"; }]; }
          { action = [{ SwitchToMode = "Search"; }]; key = [{ Char = "s"; }]; }
        ];
      };
    };
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
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };
  };
}
