{ pkgs, lib, ... }:
''
  argparse 's/stable' -- $argv
  or return 1

  set usage "alias for nix run" "nr [-s|--stable] package"

  if test (count $argv) -eq 0
      printf "%s\n" $usage
      return
  end

  set pkg $argv[1]
  set rest $argv[2..-1]

  if set -q _flag_s
      env NIXPKGS_ALLOW_UNFREE=1 ${lib.getExe pkgs.nix} run --impure $DOTFILES#stable.$pkg -- $rest
  else
      env NIXPKGS_ALLOW_UNFREE=1 ${lib.getExe pkgs.nix} run --impure $DOTFILES#$pkg -- $rest
  end
''
