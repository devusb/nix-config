{ pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/pull/356133
  nixpkgs.overlays = [
    (final: prev:
      let
        inherit (pkgs) fetchpatch2;
        curl = prev.curl.overrideAttrs (old: {
          patches = [
            (fetchpatch2 {
              url = "https://github.com/curl/curl/commit/f5c616930b5cf148b1b2632da4f5963ff48bdf88.patch";
              hash = "sha256-eVnlZ4IwkYBRqe3inuaWKig1i4+PcUcXY13wEjkhy+Q=";
            })
            (fetchpatch2 {
              url = "https://github.com/curl/curl/commit/0cdde0fdfbeb8c35420f6d03fa4b77ed73497694.patch";
              hash = "sha256-mDtbfCl2uKFVZjwXWCnjcDYlAaLNUMbOUFG7g1EEGwA=";
            })
          ];
        });
        git = prev.git.override {
          inherit curl;
        };
      in
      {
        nix = prev.nix.override {
          inherit git curl;
        };
        nix-eval-jobs = prev.nix-eval-jobs.override {
          inherit curl;
        };
      })
  ];

}
