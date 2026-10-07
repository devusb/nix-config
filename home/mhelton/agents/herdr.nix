{
  lib,
  pkgs,
  ...
}:
let
  collie = pkgs.llm-agents.collie.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp -r web/src $out/lib/collie/web/src
      cp -r docs $out/lib/collie/docs
      cp *.md $out/lib/collie/
      makeWrapper ${lib.getExe pkgs.bun} $out/bin/collie \
        --add-flags "run $out/lib/collie/cli/main.ts"
    '';
  });

  sessionFork = pkgs.stdenvNoCC.mkDerivation {
    pname = "herdr-session-fork";
    version = "0.1.0-unstable-2026-09-22";
    src = pkgs.fetchFromGitHub {
      owner = "DanielGnzlzVll";
      repo = "herdr-session-fork";
      rev = "28c534565b3edc3b61cea51bb9790d5818eecd66";
      hash = "sha256-YG/iLM7dpH2o+L/WGS31EReHvwYOQzifj9qXQ9rraTo=";
    };
    buildInputs = [ pkgs.bash ];
    installPhase = ''
      cp -r . $out
      patchShebangs $out/scripts
      sed -i '2i export PATH=${
        lib.makeBinPath [
          pkgs.jq
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.gawk
        ]
      }:$PATH' $out/scripts/*.sh
      substituteInPlace $out/herdr-plugin.toml --replace-fail '"bash"' '"${lib.getExe pkgs.bash}"'
    '';
  };
in
{
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
    claudeCodeHooks.enable = true;

    plugins = {
      "danielgnzlzvll.session-fork".package = sessionFork;
    };

    settings = {
      onboarding = false;

      keys = {
        command = [
          {
            key = "prefix+shift+v";
            type = "plugin_action";
            command = "danielgnzlzvll.session-fork.clone-vertical";
            description = "fork session right";
          }
          {
            key = "prefix+_";
            type = "plugin_action";
            command = "danielgnzlzvll.session-fork.clone-horizontal";
            description = "fork session below";
          }
        ];
      };
    };
  };

  services.collie.package = collie;
}
