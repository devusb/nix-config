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

    gnome = prev.gnome.overrideScope' (gself: gsuper: {
      mutter = gsuper.mutter.overrideAttrs (old: {
        patches = [
          # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2948
          (prev.fetchurl {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/20e2adc4fc0549a394a18cf207ad32b42b142d4f.patch";
            sha256 = "sha256-6uvh/itSYNPlWswYo7a1ESfsIIc/Ag6BTWypouIWlD0=";
          })
          # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2954
          (prev.fetchurl {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2954/diffs.patch";
            sha256 = "sha256-jFoOd/hctFhkU0tNSNxuMzZTlihYOflkhRv9Szvd0Us=";
          })
          # https://gitlab.gnome.org/GNOME/mutter/-/issues/2690
          (prev.fetchurl {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2952/diffs.patch";
            sha256 = "sha256-eceXbMeGQCiC9V7XMEN3oDcw4ZmOBh5KAoe1xau6Lg8=";
          })
        ];
      });
    });
  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
