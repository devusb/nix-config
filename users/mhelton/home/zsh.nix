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
            name = "zsh-histdb-skim";
            src = pkgs.fetchFromGitHub {
                owner = "devusb";
                repo = "zsh-histdb-skim";
                rev = "6c53f58072722fcf62954302ff9490c8f6e1e558";
                sha256 = "PcIVE/mpij7P6xun0ZLE9VmPirb3C0qXmwyqZZiXe38=";
                fetchSubmodules = true;
                };
            }
        ];
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