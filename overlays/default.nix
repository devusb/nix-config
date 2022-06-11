{ inputs, ... }: final: prev: {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  
  python39 = prev.python39.override (rec {
    packageOverrides = final: prev: {
      jsonschema = prev.jsonschema.overrideAttrs (old: {checkInputs = [];});
    };
  });
} // import ../pkgs { pkgs = final; }