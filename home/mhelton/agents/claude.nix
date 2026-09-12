{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe getExe' genAttrs;

  toLang = lang: exts: genAttrs exts (_: lang);
in
{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;

    lspServers = {
      gopls = {
        command = getExe pkgs.gopls;
        extensionToLanguage = {
          ".go" = "go";
          ".mod" = "go.mod";
          ".sum" = "go.sum";
        };
      };
      nixd = {
        command = getExe pkgs.nixd;
        extensionToLanguage = toLang "nix" [ ".nix" ];
      };
      rust-analyzer = {
        command = getExe pkgs.rust-analyzer;
        extensionToLanguage = toLang "rust" [ ".rs" ];
      };
      pyright = {
        command = getExe' pkgs.pyright "pyright-langserver";
        args = [ "--stdio" ];
        extensionToLanguage = toLang "python" [
          ".py"
          ".pyi"
          ".pyw"
        ];
      };
      fish-lsp = {
        command = getExe pkgs.fish-lsp;
        args = [ "start" ];
        extensionToLanguage = toLang "fish" [ ".fish" ];
      };
      cmake-language-server = {
        command = getExe pkgs.cmake-language-server;
        extensionToLanguage = toLang "cmake" [ ".cmake" ];
      };
      typescript = {
        command = getExe pkgs.typescript-language-server;
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".ts" = "typescript";
          ".tsx" = "typescriptreact";
          ".js" = "javascript";
          ".jsx" = "javascriptreact";
          ".mjs" = "javascript";
          ".cjs" = "javascript";
          ".mts" = "typescript";
          ".cts" = "typescript";
        };
      };
      yamlls = {
        command = getExe pkgs.yaml-language-server;
        args = [ "--stdio" ];
        extensionToLanguage = toLang "yaml" [
          ".yaml"
          ".yml"
        ];
      };
      jsonls = {
        command = getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".json" = "json";
          ".jsonc" = "jsonc";
        };
      };
    };

    settings = {
      enabledPlugins = {
        "code-review@claude-plugins-official-flake" = true;
        "superpowers@superpowers-dev" = true;
        "frontend-design@claude-plugins-official-flake" = true;
        "flox@flox-skills" = true;
      };

      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };

      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      };

      hooks = {
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "if [ -d .flox ]; then echo 'This project uses Flox. Run `flox activate` in your shell before running any commands to ensure the correct environment is loaded.'; fi";
              }
            ];
          }
        ];
      };

      autoDreamEnabled = true;
      skipDangerousModePermissionPrompt = true;
      skipAutoPermissionPrompt = true;
      voiceEnabled = true;
    };
  };
}
