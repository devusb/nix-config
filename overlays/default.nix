{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    devenv = inputs.devenv.packages.${prev.system}.devenv;

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

    # override until https://github.com/NixOS/nixpkgs/pull/206211 hits unstable
    ipmiview = prev.ipmiview.overrideAttrs (old: rec {
      inherit (old) pname;
      version = "2.21.0";
      buildVersion = "221118";

      src = prev.fetchurl {
        url = "https://www.supermicro.com/wftp/utility/IPMIView/Linux/IPMIView_${version}_build.${buildVersion}_bundleJRE_Linux_x64.tar.gz";
        hash = "sha256-ZN0vadGbjGj9U2wPqvHLjS9fsk3DNCbXoNvzUfnn8IM=";
      };
    });

  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
