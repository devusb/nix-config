{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    # joycond
    joycond = prev.joycond.overrideAttrs (old: {
      version = "0.1.0-unstable-2023-12-03";
      src = prev.fetchFromGitHub {
        owner = "DanielOgorchock";
        repo = old.pname;
        rev = "9d1f5098b716681d087cca695ad714218a18d4e8";
        hash = "sha256-LT40EqBMaG6Wwl9AvhOxLNmolgUPSl5IkryOqIGAOCE=";
      };
    });

    oil-nvim-git = prev.vimPlugins.oil-nvim.overrideAttrs (old: {
      version = "2024-04-26";
      src = prev.fetchFromGitHub {
        owner = "stevearc";
        repo = "oil.nvim";
        rev = "f3a31eba24587bc038592103d8f7e64648292115";
        hash = "sha256-JlA5/qU3U/uAuNt9iVIsIUnULxtxpzoO49ooF8MY3gw=";
        fetchSubmodules = true;
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
