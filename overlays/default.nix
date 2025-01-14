{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    teams-for-linux = prev.teams-for-linux.overrideAttrs (old: {
      desktopItems = [
        (prev.makeDesktopItem {
          name = old.pname;
          exec = "${old.pname} %u";
          icon = old.pname;
          desktopName = "Microsoft Teams for Linux";
          comment = old.meta.description;
          categories = [
            "Network"
            "InstantMessaging"
            "Chat"
          ];
          mimeTypes = [
            "x-scheme-handler/msteams"
          ];
        })
      ];
    });

    # https://codeberg.org/avery42/delfin/pulls/142
    delfin = prev.delfin.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (prev.fetchpatch2 {
          url = "https://codeberg.org/avery42/delfin/commit/015e910b6fd2336d1fb153ad9209c7f4f322d37f.diff";
          hash = "sha256-GQk8bPO6RVW8DuZn837cXAqM7dtcgDNTckf7vngU3YY=";
        })
      ];
    });

    kde-rounded-corners = prev.kde-rounded-corners.overrideAttrs (old: rec {
      version = "0.7.0";
      srv = old.src.override {
        rev = "v${version}";
        hash = "sha256-6uSgYFY+JV8UCy3j9U/hjk6wJpD1XqpnXBqmKVi/2W0=";
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
inputs.nixpkgs.lib.composeManyExtensions [
  customPkgs
  modifications
]
