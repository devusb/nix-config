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
  inputs.llm-agents.overlays.shared-nixpkgs
]
