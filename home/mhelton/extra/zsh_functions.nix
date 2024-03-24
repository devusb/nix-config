{ pkgs, ... }: ''
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
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix run --impure --system x86_64-darwin $DOTFILES\#stable.$1 -- $@[2,-1]
      elif (( $#flag_x86 )); then
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix run --impure --system x86_64-darwin $DOTFILES\#$1 -- $@[2,-1]
      elif (( $#flag_stable )); then
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix run --impure $DOTFILES\#stable.$1 -- $@[2,-1]
      else
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix run --impure $DOTFILES\#$1 -- $@[2,-1]
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
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix shell --impure --system x86_64-darwin $DOTFILES\#stable.$^@
      elif (( $#flag_x86 )); then
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix shell --impure --system x86_64-darwin $DOTFILES\#$^@
      elif (( $#flag_stable )); then
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix shell --impure $DOTFILES\#stable.$^@
      else
          NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix shell --impure $DOTFILES\#$^@
      fi
  }

  wttr () {
      ${pkgs.curl}/bin/curl "https://wttr.in/$1?u"
  }
''
