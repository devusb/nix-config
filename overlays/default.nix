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

  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
