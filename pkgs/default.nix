{ prev, ... }:
let
  pkgs = prev;
in
{

  # python packages
  pythonPackagesExtensions = pkgs.pythonPackagesExtensions ++ [
    (self: super: {
    })
  ];

}
