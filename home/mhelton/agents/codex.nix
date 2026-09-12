{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  superpowersManifest = builtins.fromJSON (
    builtins.readFile "${inputs.superpowers}/.claude-plugin/marketplace.json"
  );
  superpowersMarketplaceManifest = pkgs.writeText "superpowers-marketplace.json" (
    builtins.toJSON (
      superpowersManifest
      // {
        plugins = map (
          plugin:
          plugin
          // {
            source = "./plugins/superpowers";
          }
        ) superpowersManifest.plugins;
      }
    )
  );
  superpowersMarketplace = pkgs.linkFarm "codex-marketplace-superpowers" {
    ".claude-plugin/marketplace.json" = superpowersMarketplaceManifest;
    "plugins/superpowers" = inputs.superpowers;
  };
in
{
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
    enableMcpIntegration = true;
    marketplaces.superpowers-dev = lib.mkForce superpowersMarketplace;
    settings = {
      default_permissions = "git-workspace";
      approval_policy = "on-request";
      approvals_reviewer = "auto_review";
      permissions."git-workspace".extends = ":workspace";
      plugins = {
        "flox@flox-skills".enabled = true;
        "superpowers@superpowers-dev".enabled = true;
        "frontend-design@claude-plugins-official".enabled = true;
        "code-review@claude-plugins-official".enabled = true;
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
