{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    flox = inputs.flox.packages.${prev.system}.flox;

    # steam input and pipewire support
    retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs (old: {
      postInstall = ''
        cp $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad.cfg' $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg'
        substituteInPlace $out/share/libretro/autoconfig/udev/'Microsoft X-Box 360 pad 0.cfg' \
          --replace-fail "pad" "pad 0"
      '';
    });

    lix = prev.lixPackageSets.latest.lix;

    # https://github.com/atuinsh/atuin/pull/2902
    atuin = prev.atuin.overrideAttrs (old: {
      patches = [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/atuinsh/atuin/pull/2902.diff";
          hash = "sha256-V/mSaUxn6RJwwaPwoYeyxt2b8cj5f7pU5oUE88k76M8=";
        })
      ];
    });

    chiaki-ng = prev.chiaki-ng.overrideAttrs {
      postPatch = ''
        substituteInPlace gui/CMakeLists.txt \
          --replace-fail 'Qt6 REQUIRED COMPONENTS Core Gui' 'Qt6 REQUIRED COMPONENTS Core Gui GuiPrivate'
      '';
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
]
