{ inputs, ... }: final: prev: rec {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  mpack = inputs.mpack.packages.${prev.system}.mpack;
  mach-nix = inputs.mach-nix.packages.${prev.system}.mach-nix;
  awscli2 = prev.awscli2.override { python3 = stable.python3; };
} // import ../pkgs { pkgs = final; }