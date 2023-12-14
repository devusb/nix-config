{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: rec {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    attic = inputs.attic.packages.${prev.system}.attic-client;
    devenv = inputs.devenv.packages.${prev.system}.devenv;
    deckbd = inputs.deckbd.packages.${prev.system}.default;

    # bump openjk version
    openjk = prev.openjk.overrideAttrs (old: {
      version = "unstable-2023-04-20";
      src = prev.fetchFromGitHub {
        owner = "JACoders";
        repo = "OpenJK";
        rev = "f1448bc2c04d13f259a88dd2a22d6b3c6fa68772";
        sha256 = "sha256-jTZz1TjjobZmJcwtR3o0QtTWASMSXcUav6oRAEPDMJU=";
      };
    });

    # bump john version
    john = prev.john.overrideAttrs (old: {
      version = "unstable-2023-06-02";
      src = prev.fetchFromGitHub {
        owner = "openwall";
        repo = "john";
        rev = "7c73ca9003b2392727fbc4de137fc96a38f82c7e";
        sha256 = "sha256-TRAxfLBgMA4xQs77ThdRd9uscLNXqF9ycvE6LeYDsSY=";
      };
      patches = [ ]; # patches have been upstreamed
    });

    # starship PR for aws-sso-cli
    starship = prev.starship.overrideAttrs (old: {
      patches = [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/starship/starship/pull/5028.diff";
          hash = "sha256-k6b57kPs6H6DcloRAB85a8g/ixO5QgtxNKEzzON5PMI=";
        })
      ];
      checkFlags = [
        "--skip=modules::aws::tests::expiration_date_set"
      ];
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

    # bump chiaki for HDR
    chiaki4deck = prev.chiaki4deck.overrideAttrs (old: {
      version = "1.5.0-unstable-2023-12-14";
      src = prev.fetchFromGitHub {
        owner = "streetpea";
        repo = old.pname;
        rev = "e641d82762cbb5a729648a37b6e77c14e1027a0c";
        hash = "sha256-H8E/mx+n7bCZ99+yodJ7tGNh2TV8T7FXLeGMHlCdeUo=";
        fetchSubmodules = true;
      };
    });

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (self: super: {
        # skip additional tests that seem to require network access
        slack-sdk = super.slack-sdk.overrideAttrs (old: {
          disabledTests = old.disabledTests ++ [
            "test_web_client_http_retry"
            "test_web_client_http_retry_connection"
          ];
        });
      })
    ];
  };

in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
