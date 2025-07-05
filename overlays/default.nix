{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    flox = inputs.flox.packages.${prev.system}.flox;

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

    # steam input and pipewire support
    retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs (old: {
      postInstall = ''
        cp $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad.cfg' $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg'
        substituteInPlace $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg' \
          --replace-fail "pad" "pad 0"
      '';
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
