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
        "ns [-x|--x86] [-s|--stable] package1 package2"
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
        nix shell --system x86_64-darwin nixpkgs-stable#$^@
    elif (( $#flag_x86 )); then
        nix shell --system x86_64-darwin nixpkgs#$^@
    elif (( $#flag_stable )); then
        nix shell nixpkgs-stable#$^@
    else
        nix shell nixpkgs#$^@
    fi
}
