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
            # will source zsh-autosuggestions.plugin.zsh
            name = "zsh-histdb";
            src = pkgs.fetchFromGitHub {
                owner = "larkery";
                repo = "zsh-histdb";
                rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
                sha256 = "PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
                fetchSubmodules = true;
                };
            }
        ];
    };
}