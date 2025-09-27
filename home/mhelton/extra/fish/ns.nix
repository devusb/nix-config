{ pkgs, lib, ... }:
''
  argparse 's/stable' -- $argv
  or return 1

  set usage "alias for nix shell" "ns [-s|--stable] package1 package2"

  if test (count $argv) -eq 0
      printf "%s\n" $usage
      return
  end

  if set -q _flag_s
      env NIXPKGS_ALLOW_UNFREE=1 ${lib.getExe pkgs.nix} shell --impure $DOTFILES#stable.$argv
  else
      env NIXPKGS_ALLOW_UNFREE=1 ${lib.getExe pkgs.nix} shell --impure $DOTFILES#$argv
  end
''
