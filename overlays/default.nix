{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    devenv = inputs.devenv.packages.${prev.system}.devenv;
    attic = inputs.attic.packages.${prev.system}.attic;
    nixgl = inputs.nixgl.packages.${prev.system};
    nix-search = inputs.nix-search-cli.packages.${prev.system}.nix-search;

    ryujinx-git = prev.ryujinx.overrideAttrs (old: rec {
      inherit (old) pname;
      version = "2023-03-06";

      src = prev.fetchFromGitHub {
        owner = "riperiperi";
        repo = "Ryujinx";
        rev = "7801d2d14d6ad0a7d55d0c07a36aeae207b3427b";
        sha256 = "sha256-jwgAEXep87QaeQImk/tdpehsUVU+ELpJc7rgbY5my90=";
      };
    });

  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
