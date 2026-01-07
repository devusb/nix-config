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

      chiaki-ng = prev.chiaki-ng.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          (prev.lib.cmakeBool "CHIAKI_ENABLE_TESTS" false)
        ];
      });

      gnome-network-displays = prev.gnome-network-displays.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          # Find the nd-stream.c file and patch it
          echo "Looking for nd-stream.c file..."
          find . -name "nd-stream.c" -type f | while read -r file; do
            echo "Found file at: $file"
            substituteInPlace "$file" \
              --replace "XDP_OUTPUT_MONITOR | XDP_OUTPUT_WINDOW | XDP_OUTPUT_VIRTUAL" \
                        "XDP_OUTPUT_MONITOR"
          done
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
        })
      ];
    };
in
inputs.nixpkgs.lib.composeManyExtensions [
  customPkgs
  modifications
]
