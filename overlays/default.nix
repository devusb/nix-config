{ inputs, ... }: final: prev: {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
} // import ../pkgs { pkgs = final; }