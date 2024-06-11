{ inputs, ... }:
let
  customPkgs = final: prev: import ../pkgs { inherit final prev; };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; };
    mpack = inputs.mpack.packages.${prev.system}.mpack;
    colmena = inputs.colmena.packages.${prev.system}.colmena;

    # joycond
    joycond = prev.joycond.overrideAttrs (old: {
      version = "0.1.0-unstable-2023-12-03";
      src = prev.fetchFromGitHub {
        owner = "DanielOgorchock";
        repo = old.pname;
        rev = "9d1f5098b716681d087cca695ad714218a18d4e8";
        hash = "sha256-LT40EqBMaG6Wwl9AvhOxLNmolgUPSl5IkryOqIGAOCE=";
      };
    });

    obsidian = prev.obsidian.overrideAttrs (old: rec {
      filename = if prev.stdenv.isDarwin then "Obsidian-${old.version}-universal.dmg" else "obsidian-${old.version}.tar.gz";
      src = prev.fetchurl {
        url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${old.version}/${filename}";
        hash = if prev.stdenv.isDarwin then "sha256-o5ELpG82mJgcd9Pil6A99BPK6Hoa0OKJJkYpyfGJR9I=" else "sha256-ho8E2Iq+s/w8NjmxzZo/y5aj3MNgbyvIGjk3nSKPLDw=";
      };
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
