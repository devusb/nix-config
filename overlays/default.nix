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
      dms = inputs.dank-material-shell.packages.${system};

      dms-shell = final.dms.dms-shell;

      # steam input and pipewire support
      retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs (old: {
        postInstall = ''
          cp $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad.cfg' $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg'
          substituteInPlace $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg' \
            --replace-fail "pad" "pad 0"
        '';
      });

      # 8.x detects CEC device node removal and no longer pins /dev/cec0: https://github.com/Pulse-Eight/libcec/issues/668
      libcec = prev.libcec.overrideAttrs (old: rec {
        version = "8.1.7";
        src = old.src.override {
          rev = "libcec-${version}";
          sha256 = "sha256-teh4w6pDn0HJ9W0FnqhnMYFBd6JxgK9QYfVqYHXviiI=";
        };
      });

      chiaki-ng = prev.chiaki-ng.overrideAttrs (old: {
        version = "1.10.0-unstable-2026-07-04";
        src = old.src.override {
          tag = null;
          rev = "6547d8aed03503646fe1043512616e26c03fa9db";
          hash = "sha256-Eb7LCfb58TT7zTSl+/j5/ImP+4LDJdcbODPmgJ/YXK0=";
        };
        patches = [ ];
      });

      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          # fix for xwayland screen size lagging behind output mode changes: https://github.com/Supreeeme/xwayland-satellite/pull/495
          (prev.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/Supreeeme/xwayland-satellite/pull/495.patch";
            hash = "sha256-XqxdSAiX7lPduZw4WtfCDyJbpHKEDcJgYwaUr3ZVa7w=";
          })
          # fix for steam menu not staying open: https://github.com/Supreeeme/xwayland-satellite/pull/494
          (prev.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/Supreeeme/xwayland-satellite/pull/494.patch";
            hash = "sha256-efUsFsMCDp9Oj0lQJGc2yBDJzIahh7G9QZwlZ8hanJQ=";
          })
        ];
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
