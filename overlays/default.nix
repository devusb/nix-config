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
      ghostty-git = inputs.ghostty.packages.${system}.default;

      # steam input and pipewire support
      retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs (old: {
        postInstall = ''
          cp $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad.cfg' $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg'
          substituteInPlace $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg' \
            --replace-fail "pad" "pad 0"
        '';
      });

      chiaki-ng = prev.chiaki-ng.overrideAttrs (old: {
        version = "1.10.0-unstable-2026-05-17";
        src = old.src.override {
          tag = null;
          rev = "4a0115e1b3fd3dd98384962b9779dea866122ba5";
          hash = "sha256-+zQbdLSlhxXYnocVbSbHTysQu8LdQnobKwrD9qAjuMg=";
        };
        patches = [ ];
      });

      aws-sso-cli = prev.aws-sso-cli.overrideAttrs (old: rec {
        version = "2.2.2";
        src = old.src.override {
          rev = "v${version}";
          hash = "sha256-xUq9rUSDV/FY4eHfx2afBW8Rvu/RI9vOhCRnWOJEY0k=";
        };
        vendorHash = "sha256-euqhgbyz8H/fQ1RAP0k4GMOjOu7gVeYzQv75tjCh5z0=";
        postPatch = (old.postPatch or "") + ''
          substituteInPlace go.mod --replace "go 1.26.3" "go 1.26.2"
        '';
        doCheck = false;
      });

      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };

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
  inputs.llm-agents.overlays.default
]
