{ pkgs, config, system, ...}: {
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        enableCompletion = true;
        shellAliases = {
            ll = "exa -l --git --icons";
            ls = "exa --icons";
            update = if system == "aarch64-darwin" then "darwin-rebuild switch --flake ~/code/nix-config/ && rm result" else "nixos-rebuild switch --use-remote-sudo --flake /dotfiles/";
            update-home = if system == "aarch64-darwin" then "home-manager switch --flake ~/code/nix-config/" else "home-manager switch --flake /dotfiles/";
            kb = "kubectl";
            cat = "bat --paging=always";
        };
        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };
        completionInit = ''
            autoload -U +X bashcompinit && bashcompinit
            complete -o nospace -C vault vault
        '';
        initExtra = ''
            if [ -e ~/.env ]; then
            source ~/.env
            fi
            source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
        ''
        ;
    };
    programs.keychain = {
        enable = true;
        enableZshIntegration = true;
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
        settings = {
            sync_address = "https://atuin.gaia.devusb.us";
            auto_sync = true;
            sync_frequency = "5m";
            search_mode = "fulltext";
        };
    };
}
