{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications =
    final: prev:
    let
      system = prev.stdenv.hostPlatform.system;
    in
    {
      stable = import inputs.nixpkgs-stable { inherit system; };
      colmena = inputs.colmena.packages.${system}.colmena;
      flox = inputs.flox.packages.${system}.flox;
      wolweb-cli = inputs.wolweb-cli.packages.${system}.wolweb-cli;

      # steam input and pipewire support
      retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs (old: {
        postInstall = ''
          cp $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad.cfg' $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg'
          substituteInPlace $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg' \
            --replace-fail "pad" "pad 0"
        '';
      });

      git-absorb = prev.git-absorb.overrideAttrs (old: {
        version = "0.8.0-unstable-2025-09-13";
        src = old.src.override {
          tag = null;
          rev = "3a1148ea2df3ca41cb69df8848f99d25e66dc0b5";
          hash = "sha256-CrpLWDHSnT2PgbLFDK6UyaeKgmW1mygvSIudsl/nbbQ=";
        };
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
        })
      ];
    };
in
inputs.nixpkgs.lib.composeManyExtensions [
  customPkgs
  modifications
]
