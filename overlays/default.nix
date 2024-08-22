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

    chiaki4deck = prev.chiaki4deck.override {
      libplacebo = prev.libplacebo.overrideAttrs (old: {
        version = "6.338.2-unstable-2024-01-29";
        src = old.src.override {
          rev = "c320f61e601caef2be081ce61138e5d51c1be21d";
          hash = "sha256-ZlKYgWz/Rkp4IPt6cJ+KNnzBB2s8jGZEamSAOIGyDuE=";
        };
      });
    };

    aws-sso-cli = prev.aws-sso-cli.overrideAttrs (old: {
      checkFlags =
        let
          skippedTests = [
            "TestAWSConsoleUrl"
            "TestAWSFederatedUrl"
            "TestServerWithSSL" # https://github.com/synfinatic/aws-sso-cli/issues/1030 -- remove when version >= 2.x
          ] ++ prev.lib.optionals prev.stdenv.isDarwin [ "TestDetectShellBash" ];
        in
        [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
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
