{ inputs, ... }: final: prev:
let
  inherit (builtins) mapAttrs;
in
{
  stable = import inputs.nixpkgs-stable { system = prev.system; };
} // import ../pkgs { pkgs = final; }