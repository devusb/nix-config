{
  pkgs,
  ...
}:
{
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
    claudeCodeHooks.enable = true;

    settings = {
      onboarding = false;
    };
  };
}
