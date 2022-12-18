{ inputs, ... }:
let
  customPkgs = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++
      # https://github.com/NixOS/nixpkgs/issues/175875
      (if (prev.stdenv.isDarwin && prev.stdenv.isAarch64) then [
        (
          self: super: {
            pyopenssl = super.pyopenssl.overrideAttrs (old: {
              meta = old.meta // { broken = false; };
            });
          }
        )
      ] else [ ]);

    # pin zellij to last version before switch to kdl configs https://github.com/zellij-org/zellij/pull/1759
    zellij = prev.zellij.overrideAttrs (old: rec {
      inherit (old) pname;
      version = "0.31.3";

      src = prev.fetchFromGitHub {
        owner = "zellij-org";
        repo = "zellij";
        rev = "v${version}";
        sha256 = "sha256-4iljPNw/tS/COStARg2PlrCoeE0lkSQ5+r8BrnxFLMo=";
      };

      cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-GMEQRGTzGPVK3DZXGshrVrFavQz6erC08w0nqjKNMpo=";
      });
    });

  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
