{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    awscli2 = prev.awscli2.overrideAttrs (old: {
      postPatch =
        old.postPatch
        + ''
          substituteInPlace pyproject.toml \
            --replace-fail 'flit_core>=3.7.1,<3.9.1' 'flit_core>=3.7.1'
        '';
    });

    heroic = prev.heroic.override {
      heroic-unwrapped = prev.heroic-unwrapped.override {
        electron = prev.electron_31-bin;
      };
    };

    lutris = prev.lutris.override {
      lutris-unwrapped = prev.lutris-unwrapped.override {
        xboxdrv = final.stable.xboxdrv;
      };
    };

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
