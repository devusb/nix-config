{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    gitlab-ci-local = prev.gitlab-ci-local.overrideAttrs (old: rec {
      version = "4.54.0-unstable-2024-10-16";
      src = old.src.override {
        rev = "b3434b547b2757c2d5af4e1c5d252c1df4699fd5";
        hash = "sha256-XwTjlZW8urGqMvnF5bvjL1+dt2C08wnbjFNb4mp2jQo=";
      };
      npmDepsHash = "sha256-uNjPwh6oBUGR4Pw9ievHFllU8q4pigCwVFOTiyVOwMY=";
      npmDeps = final.fetchNpmDeps {
        inherit src;
        name = "${old.pname}-${version}-npm-deps";
        hash = npmDepsHash;
      };
    });

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
