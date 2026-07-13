{ inputs, pkgs, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      mesa_git = prev.mesa_git.overrideAttrs (old: {
        patches = old.patches ++ [
        ];
      });
      mesa32_git = prev.mesa32_git.overrideAttrs (old: {
        patches = old.patches ++ [
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
