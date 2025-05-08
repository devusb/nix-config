{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
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

    atuin = prev.atuin.overrideAttrs (old: {
      patches = (prev.patches or [ ]) ++ [
        # https://github.com/atuinsh/atuin/pull/2715
        (prev.fetchpatch {
          url = "https://github.com/atuinsh/atuin/commit/cab77ffc649f62e0ab3bf491c85ddd4dde0841ef.patch";
          hash = "sha256-Q9PYbPR9EDO94QH2GVa07ngMIbI8qlkaqHXU0bwCPok=";
        })
      ];
    });

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (self: super: {
        # skip additional tests that seem to require network access
        slack-sdk = super.slack-sdk.overridePythonAttrs (old: {
          disabledTests = old.disabledTests ++ [
            "test_web_client_http_retry"
            "test_web_client_http_retry_connection"
            "test_webhook_http_retry"
            "test_issue_690_oauth_v2_access"
          ];
        });
        weasyprint = super.weasyprint.overridePythonAttrs (old: {
          doCheck = if prev.stdenv.hostPlatform.isDarwin then false else true;
        });
      })
    ];
  };
in
inputs.nixpkgs.lib.composeManyExtensions [
  customPkgs
  modifications
]
