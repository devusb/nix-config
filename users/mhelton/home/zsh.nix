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

            nr() {
                local flag_x86 flag_stable
                local usage=(
                    "alias for nix run"
                    "nr [-x|--x86] [-s|--stable] package"
                )

                zmodload zsh/zutil
                zparseopts -D -F -K -- \
                    {s,-stable}=flag_stable \
                    {x,-x86}=flag_x86 ||
                    return 1

                if ((# == 0)); then
                    print -l $usage
                    return
                elif (( $#flag_x86 && $#flag_stable )); then
                    nix run --system x86_64-darwin nixpkgs-stable#$1 -- $@[2,-1]
                elif (( $#flag_x86 )); then
                    nix run --system x86_64-darwin nixpkgs#$1 -- $@[2,-1]
                elif (( $#flag_stable )); then
                    nix run nixpkgs-stable#$1 -- $@[2,-1]
                else
                    nix run nixpkgs#$1 -- $@[2,-1]
                fi
            }
            
            ns() {
                local flag_x86 flag_stable
                local usage=(
                    "alias for nix shell"
                    "ns [-x|--x86] [-s|--stable] package"
                )

                zmodload zsh/zutil
                zparseopts -D -F -K -- \
                    {s,-stable}=flag_stable \
                    {x,-x86}=flag_x86 ||
                    return 1

                if ((# == 0)); then
                    print -l $usage
                    return
                elif (( $#flag_x86 && $#flag_stable )); then
                    nix shell --system x86_64-darwin nixpkgs-stable#$1 -- $@[2,-1]
                elif (( $#flag_x86 )); then
                    nix shell --system x86_64-darwin nixpkgs#$1 -- $@[2,-1]
                elif (( $#flag_stable )); then
                    nix shell nixpkgs-stable#$1 -- $@[2,-1]
                else
                    nix shell nixpkgs#$1 -- $@[2,-1]
                fi
            }
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
            shlvl.disabled = false;
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
