{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
    enableMcpIntegration = true;
    settings = {
      default_permissions = "git-workspace";
      approval_policy = "on-request";
      approvals_reviewer = "auto_review";
      permissions."git-workspace".extends = ":workspace";
    };
  };

  home.file.".codex/config.toml".enable = false;

  home.activation.seedCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codexConfig="$HOME/.codex/config.toml"
    if [ ! -e "$codexConfig" ]; then
      install -Dm644 ${
        (pkgs.formats.toml { }).generate "codex-config" config.programs.codex.settings
      } "$codexConfig"
    fi
  '';

}
