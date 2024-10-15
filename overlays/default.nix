{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    devenv' = prev.devenv;

    ripgrep-all = prev.ripgrep-all.overrideAttrs (old:
      let
        path = with prev; [
          ffmpeg
          pandoc
          poppler_utils
          ripgrep
          zip
          fzf
        ];
      in
      {
        postInstall = ''
          for bin in $out/bin/*; do
            if [[ $bin != *.dSYM ]]; then
              wrapProgram $bin \
                --prefix PATH ":" "${prev.lib.makeBinPath path}"
            fi
          done
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
