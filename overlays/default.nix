{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: rec {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    small = import inputs.nixpkgs-small { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    attic = inputs.attic.packages.${prev.system}.attic-client;
    nixgl = inputs.nixgl.packages.${prev.system};
    nix-search = inputs.nix-search-cli.packages.${prev.system}.nix-search;
    devenv = inputs.devenv.packages.${prev.system}.devenv;

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

    # bump chiaki4deck
    chiaki4deck = prev.chiaki4deck.overrideAttrs (old: rec {
      inherit (old) pname;
      version = "1.4.1";

      src = prev.fetchFromGitHub {
        owner = "streetpea";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-W/t9uYApt8j5UMjtVWhFtq+IHmu9vi6M92I8N4kRtEk=";
        fetchSubmodules = true;
      };
    });

    # bump aws-sso-cli
    aws-sso-cli =
      (
        let
          version = "1.14.2";
          src = prev.fetchFromGitHub {
            owner = "synfinatic";
            repo = "aws-sso-cli";
            rev = "v${version}";
            hash = "sha256-KtSmDBr2JRxyBUJ5UWMmnfN87oO1/TiCrtuxA2b9Ph0=";
          };
        in
        prev.aws-sso-cli.override {
          buildGoModule = args: prev.buildGoModule (args // {
            inherit src version;
            vendorHash = "sha256-B7t1syBJjwaTM4Tgj/OhhmHJRAhJ/Ewg+g55AKpdj4c=";
          });
        }
      ).overrideAttrs (old: {
        checkFlags = [
          # requires network access
          "-skip=TestAWSConsoleUrl|TestAWSFederatedUrl"
        ];
      });
  };

in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
