{ prev, ... }:
let
  pkgs = prev;
in
{
  drsprinto = pkgs.callPackage ./drsprinto { };
  vibetyper = pkgs.callPackage ./vibetyper { };

  # python packages
  pythonPackagesExtensions = pkgs.pythonPackagesExtensions ++ [
    (self: super: {
    })
  ];

}
