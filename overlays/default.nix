{ inputs, ... }: final: prev: {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  mpack = inputs.mpack;
} // import ../pkgs { pkgs = final; }