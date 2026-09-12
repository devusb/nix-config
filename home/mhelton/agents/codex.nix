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
      plugins = {
        "flox@flox-skills".enabled = true;
        "superpowers@superpowers-dev".enabled = true;
      };
    };
  };

  home.file.".codex/config.toml".enable = false;

  # codex fails if it can't write config.toml, so just overwrite it every activation instead
  home.activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codexConfig="$HOME/.codex/config.toml"
    run rm -f "$codexConfig"
    run install -Dm644 ${config.home.file.".codex/config.toml".source} "$codexConfig"
  '';

}
