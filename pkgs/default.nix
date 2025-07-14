{ prev, ... }:
let
  pkgs = prev;
in
{
  drsprinto = pkgs.callPackage ./drsprinto { };

  # python packages
  pythonPackagesExtensions = pkgs.pythonPackagesExtensions ++ [
    (self: super: {
    })
  ];

}
