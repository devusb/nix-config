{ inputs, ... }: final: prev: rec {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  x86_64-darwin = import inputs.nixpkgs { system = "x86_64-darwin"; };
  mpack = inputs.mpack.packages.${prev.system}.mpack;
  mach-nix = inputs.mach-nix.packages.${prev.system}.mach-nix;

  python310 =
    if (prev.stdenv.isDarwin && prev.stdenv.isAarch64) then
      prev.python310.override
        {
          packageOverrides = self: super: {
            # https://github.com/NixOS/nixpkgs/issues/175875
            pyopenssl = super.pyopenssl.overrideAttrs (old: {
              meta = old.meta // { broken = false; };
            });

          };
        } else prev.python310;

} // import ../pkgs { pkgs = final; prev = prev; }
