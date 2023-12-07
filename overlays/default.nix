{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit prev; };

  modifications = final: prev: rec {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;
    attic = inputs.attic.packages.${prev.system}.attic-client;
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

    # https://github.com/bluez/bluez/issues/614
    bluez' = prev.bluez.overrideAttrs (old: {
      patches = old.patches ++ [
        (prev.fetchpatch {
          url = "https://github.com/bluez/bluez/commit/3a9c637010f8dc1ba3e8382abe01065761d4f5bb.patch";
          hash = "sha256-UUmYMHnxYrw663nEEC2mv3zj5e0omkLNejmmPUtgS3c=";
        })
      ];
    });

    # https://github.com/NixOS/nixpkgs/pull/272434
    ouch = prev.ouch.overrideAttrs (old: {
      preCheck = ''
        substituteInPlace tests/ui.rs \
          --replace 'format!(r"/private{path}")' 'path.to_string()'
      '';

      env = { OUCH_ARTIFACTS_FOLDER = "artifacts"; } //
        # Work around https://github.com/NixOS/nixpkgs/issues/166205.
        prev.lib.optionalAttrs prev.stdenv.cc.isClang { NIX_LDFLAGS = "-l${prev.stdenv.cc.libcxx.cxxabi.libName}"; };
    });

  };

in
inputs.nixpkgs.lib.composeManyExtensions [ customPkgs modifications ]
