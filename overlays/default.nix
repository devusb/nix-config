{ inputs, ... }: final: prev: rec {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  x86_64-darwin = import inputs.nixpkgs { system = "x86_64-darwin"; };
  mpack = inputs.mpack.packages.${prev.system}.mpack;
  mach-nix = inputs.mach-nix.packages.${prev.system}.mach-nix;

  # workaround broken pyopenssl on darwin
  python310 =
    if (prev.stdenv.isDarwin && prev.stdenv.isAarch64) then
      prev.python310.override
        {
          packageOverrides = self: super: {
            # https://github.com/NixOS/nixpkgs/issues/175875
            pyopenssl = super.pyopenssl.overrideAttrs (old: {
              meta = old.meta // { broken = false; };
            });

            # https://github.com/NixOS/nixpkgs/issues/185996
            shapely = super.shapely.overrideAttrs (old: rec {
              version = "1.8.4";
              pname = old.pname;
              src = super.fetchPypi {
                inherit pname version;
                sha256 = "sha256-oZXlHKr6IYKR8suqP+9p/TNTyT7EtlsqRyLEz0DDGYw=";
              };
              patches = builtins.elemAt old.patches 0;
              disabledTests = [ "test_info_handler" "test_error_handler" "test_error_handler_exception" ] ++ old.disabledTests;
            });

          };
        } else prev.python310;

} // import ../pkgs { pkgs = final; prev = prev; }
