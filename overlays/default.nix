{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    # fix broken platforms after https://github.com/NixOS/nixpkgs/pull/356326
    nvtopPackages = prev.nvtopPackages // {
      amd = prev.nvtopPackages.amd.overrideAttrs (old: {
        meta = old.meta // { platforms = prev.lib.platforms.linux; };
      });
    };

    gitlab-ci-local = prev.gitlab-ci-local.overrideAttrs (old: rec {
      version = "4.54.0-unstable-2024-10-16";
      src = old.src.override {
        rev = "b3434b547b2757c2d5af4e1c5d252c1df4699fd5";
        hash = "sha256-XwTjlZW8urGqMvnF5bvjL1+dt2C08wnbjFNb4mp2jQo=";
      };
      npmDepsHash = "sha256-uNjPwh6oBUGR4Pw9ievHFllU8q4pigCwVFOTiyVOwMY=";
      npmDeps = final.fetchNpmDeps {
        inherit src;
        name = "${old.pname}-${version}-npm-deps";
        hash = npmDepsHash;
      };
    });

    delfin = prev.delfin.overrideAttrs (old: rec {
      version = "0.4.7-unstable-2024-10-27";
      src = old.src.override {
        rev = "88c300b1647c95b596846461513c70c357bcf181";
        hash = "sha256-Fz1TMkgO9dQRRqgTYt/6MzseKlBWB+E1T1trsXQkSm0=";
      };
      cargoDeps = prev.rustPlatform.fetchCargoTarball {
        inherit src;
        name = "${old.pname}-${version}";
        hash = "sha256-AXZxnsbkQwl+o/DQyQljfNrienDTt+UYci2CbXLI5oU=";
      };
    });

    # add MIME type for Teams link association
    teams-for-linux = prev.teams-for-linux.overrideAttrs (old: {
      desktopItems = [
        (prev.makeDesktopItem {
          name = old.pname;
          exec = "${old.pname} %u";
          icon = old.pname;
          desktopName = "Microsoft Teams for Linux";
          comment = old.meta.description;
          categories = [ "Network" "InstantMessaging" "Chat" ];
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
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
