{ inputs, pkgs, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  nixpkgs.overlays =
    let
      doomPatch = pkgs.fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/42768.patch";
        hash = "sha256-Qb3Iz2OpHUzrYab0ivOxiAhGbWvC8SUwE9pU/fhBZAk";
      };
    in
    [
      (final: prev: {
        mesa_git = prev.mesa_git.overrideAttrs (old: {
          patches = old.patches ++ [
            doomPatch
          ];
        });
        mesa32_git = prev.mesa32_git.overrideAttrs (old: {
          patches = old.patches ++ [
            doomPatch
          ];
        });
      })
    ];

  specialisation.mesa-git.configuration = {
    chaotic.mesa-git = {
      enable = true;
      fallbackSpecialisation = false;
    };
  };
}
