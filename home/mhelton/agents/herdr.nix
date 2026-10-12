{
  lib,
  pkgs,
  ...
}:
let
  forkr = pkgs.stdenvNoCC.mkDerivation {
    pname = "herdr-forkr";
    version = "0.1.0-unstable-2026-09-10";
    src = pkgs.fetchFromGitHub {
      owner = "t4t5";
      repo = "herdr-forkr";
      rev = "1c1f6130589bf65456b6cdf398abfb5ddc1becad";
      hash = "sha256-8HthBL9G22pLKfZYAHB5e/ISr+SPCojMq3lKyQ4NakI=";
    };
    installPhase = ''
      cp -r . $out
      sed -i '2i export PATH=${
        lib.makeBinPath [
          pkgs.jq
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.gnused
        ]
      }:$PATH' $out/forkr.sh
      substituteInPlace $out/herdr-plugin.toml --replace-fail '"sh"' '"${pkgs.dash}/bin/dash"'
    '';
  };
in
{
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;

    plugins = {
      forkr.package = forkr;
    };

    settings = {
      onboarding = false;

      keys = {
        command = [
          {
            key = "prefix+shift+c";
            type = "plugin_action";
            command = "forkr.tab";
            description = "fork session into new tab";
          }
        ];
      };
    };
  };
}
