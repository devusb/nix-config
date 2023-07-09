{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    attic = inputs.attic.packages.${prev.system}.attic-client;
    nixgl = inputs.nixgl.packages.${prev.system};
    nix-search = inputs.nix-search-cli.packages.${prev.system}.nix-search;
    devenv = inputs.devenv.packages.${prev.system}.devenv;

    # bump openjk version
    openjk = prev.openjk.overrideAttrs (old: {
      version = "unstable-2023-04-20";
      src = prev.fetchFromGitHub {
        owner = "JACoders";
        repo = "OpenJK";
        rev = "f1448bc2c04d13f259a88dd2a22d6b3c6fa68772";
        sha256 = "sha256-jTZz1TjjobZmJcwtR3o0QtTWASMSXcUav6oRAEPDMJU=";
      };
    });

    # bump john version
    john = prev.john.overrideAttrs (old: {
      version = "unstable-2023-06-02";
      src = prev.fetchFromGitHub {
        owner = "openwall";
        repo = "john";
        rev = "7c73ca9003b2392727fbc4de137fc96a38f82c7e";
        sha256 = "sha256-TRAxfLBgMA4xQs77ThdRd9uscLNXqF9ycvE6LeYDsSY=";
      };
      patches = [ ]; # patches have been upstreamed
    });

    # bump heroic version
    heroic-unwrapped = prev.heroic-unwrapped.overrideAttrs (old: rec {
      version = "unstable-2023-06-04";
      src = prev.fetchFromGitHub {
        owner = "Heroic-Games-Launcher";
        repo = "HeroicGamesLauncher";
        rev = "94dcf7563062a0609fccb4f0e6acb509d683cd83";
        sha256 = "sha256-yMFQTLy7PHPBaEJOynzr2iNrm4npQirCZkSEbWYAEjc=";
      };
      offlineCache = prev.fetchYarnDeps {
        yarnLock = "${src}/yarn.lock";
        sha256 = "sha256-xiLK0D9+oL2UMD7b/9htOQJEpYCNayKW+KJ/vNVCgsw=";
      };
      patches = [ ]; # patches have been upstreamed
    });

  };

in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
