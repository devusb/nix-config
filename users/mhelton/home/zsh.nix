{ pkgs, config, ...}: {
    programs.zsh = {
        enable = true;
        shellAliases = {
            ll = "ls -l";
            update = "nixos-rebuild switch --use-remote-sudo --flake /dotfiles/";
            update-home = "home-manager switch --flake /dotfiles/";
            kb = "kubectl";
        };
        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };
        plugins = [
            {
                name = "zsh-histdb";
                src = pkgs.fetchFromGitHub {
                    owner = "larkery";
                    repo = "zsh-histdb";
                    rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
                    sha256 = "PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
                    fetchSubmodules = true;
                };
            }
            {
                name = "zsh-histdb-fzf";
                file = "fzf-histdb.zsh";
                src = pkgs.fetchFromGitHub {
                    owner = "m42e";
                    repo = "zsh-histdb-fzf";
                    rev = "055523a798acf02a67e242b3281d917f5ee4309a";
                    sha256 = "5R6XImDVswD/vTWQRtL28XHNzqurUeukfLevQeMDpuY=";
                    fetchSubmodules = true;
                };
            }
        ];
        initExtra = "bindkey '^R' histdb-fzf-widget";
    };
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
            add_newline = false;
            gcloud.disabled = true;
        };
    };
    programs.fzf = { 
        enable = true;
        enableZshIntegration = false;
    };
}