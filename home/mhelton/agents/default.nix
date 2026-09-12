{
  lib,
  config,
  inputs,
  ...
}:
let
  codexEnabled = config.programs.codex.enable;
  claudeEnabled = config.programs.claude-code.enable;

  marketplaces = {
    claude-plugins-official-flake = inputs.claude-plugins-official;
    superpowers-dev = inputs.superpowers;
    flox-skills = inputs.flox-skills;
  };

  context = ''
    ### Running commands
    - The user's shell is fish, any recommendations to run manually should be fish syntax.
    - Ask once per session if the user would rather you run commands, or if they'd rather run themselves.
    - If a command is not available, fall back to nix shell via "nix shell nixpkgs#<package> --command <command>" or '--command sh -c "cd src && make"' for multiples.

    ### Writing code
    - Always match the comment style of surrounding code; if no comments exist, don't start adding them.
    - Write comments as simple, plain factual statements. Do not include "archaeology" of how something came to be, but only a very simple statement of what it is/what it does. Nothing about what edge case it avoids, or any rationale or narrative or root causes.
    - Do not include essays in comments about identity or provenance, no blocks of text including exposition.
    - Prefer no comment to a simple one on something obvious.
    - Fixing a problem is not a reason to add a comment. If explaining rationale seems relevant (i.e. not a mistake but something learned) then put it in a commit message.
    - When making docs updates, do not include history or rationale for why something was done a particular way, only include how it works and examples if relevant and consistent with the existing content.

    ### Working in projects
    - Always start new features in a new branch+worktree in the .worktrees directory of the project repo folder and apply edits there, never in the main tree.
    - Commit in logical pieces with the goal of each commit working, and being an atomic unit of work.
    - Write commit messages in prose, explaining clearly and simply the purpose of a change, not a longwinded rationale statement or story.
    - Don't commit specs (e.g. from superpowers) unless there's already an established pattern in the repo for committing design specs (e.g. an existing docs/specs dir).
    - Use the "conventional commits" pattern for messages, erring towards "feat," "fix," and "chore" unless others make significantly more contextual sense or match repo norms better.

    ### Doing research
    - Do not make definitive statements without backing evidence.
  '';
in
{
  imports = [
    ./claude.nix
    ./codex.nix
  ];

  programs.codex = lib.mkIf codexEnabled {
    inherit context marketplaces;
  };

  programs.claude-code = lib.mkIf claudeEnabled {
    inherit context marketplaces;
  };
}
