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

    # contains fix for https://github.com/derailed/k9s/issues/3044
    k9s = prev.k9s.overrideAttrs (old: {
      version = "0.32.7-unstable-2025-02-02";
      src = old.src.override {
        rev = "e27e293eb194af2e42898f278dcc16870fba3931";
        hash = "sha256-Iy2S14pEm2jHgu8Pzscgf0JFaIRmYN55ze6kAd3n1l4=";
      };
      vendorHash = "sha256-3gYncdaQIzIa5fKqQbr3zqv9ln/4C3rcIzrwzeUEu5o=";
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
