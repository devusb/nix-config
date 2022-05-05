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
        enableZshIntegration = true;
    };
    programs.atuin = {
        enable = true;
        enableZshIntegration = true;
    };
}