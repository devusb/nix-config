{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    chiaki-ng =
      let
        chiaki-ng' = prev.chiaki-ng.overrideAttrs (old: {
          patches = [
            (prev.fetchpatch2 {
              url = "https://github.com/streetpea/chiaki-ng/commit/dd6bb01365215290e1325f4822de2f13aceea965.patch";
              hash = "sha256-gHSaInu3BPpwItc9LjcbxIjE4LeLOJC6waXjPFgJPu0=";
            })
          ];
        });
      in
      chiaki-ng'.override { libplacebo = prev.libplacebo; };

    devenv' = prev.devenv;

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (self: super: {
        # skip additional tests that seem to require network access
        slack-sdk = super.slack-sdk.overrideAttrs (old: {
          disabledTests = old.disabledTests ++ [
            "test_web_client_http_retry"
            "test_web_client_http_retry_connection"
            "test_webhook_http_retry"
            "test_issue_690_oauth_v2_access"
          ];
        });
      })
    ];
  };
in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
