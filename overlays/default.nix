{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    chiaki4deck = prev.chiaki4deck.override {
      libplacebo = prev.libplacebo.overrideAttrs (old: {
        version = "6.338.2-unstable-2024-01-29";
        src = old.src.override {
          rev = "c320f61e601caef2be081ce61138e5d51c1be21d";
          hash = "sha256-ZlKYgWz/Rkp4IPt6cJ+KNnzBB2s8jGZEamSAOIGyDuE=";
        };
      });
    };

    # https://github.com/NixOS/nixpkgs/pull/338033
    kitty = prev.kitty.overrideAttrs (old: {
      buildPhase = with prev; let
        commonOptions = ''
          --update-check-interval=0 \
          --shell-integration=enabled\ no-rc
        '';
        darwinOptions = ''
          --disable-link-time-optimization \
          ${commonOptions}
        '';
      in
      ''
        runHook preBuild

        # Add the font by hand because fontconfig does not finds it in darwin
        mkdir ./fonts/
        cp "${(nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})}/share/fonts/truetype/NerdFonts/SymbolsNerdFontMono-Regular.ttf" ./fonts/

        ${ lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) "export MACOSX_DEPLOYMENT_TARGET=11" }
        ${if stdenv.isDarwin then ''
          ${python3.pythonOnBuildForHost.interpreter} setup.py build ${darwinOptions}
          make docs
          ${python3.pythonOnBuildForHost.interpreter} setup.py kitty.app ${darwinOptions}
        '' else ''
          ${python3.pythonOnBuildForHost.interpreter} setup.py linux-package \
          --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
          --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
          --canberra-library='${libcanberra}/lib/libcanberra.so' \
          --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
          ${commonOptions}
          ${python3.pythonOnBuildForHost.interpreter} setup.py build-launcher
        ''}
        runHook postBuild
      '';
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
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
