{ inputs, ... }: final: prev: rec {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  x86_64-darwin = import inputs.nixpkgs { system = "x86_64-darwin"; };
  mpack = inputs.mpack.packages.${prev.system}.mpack;
  mach-nix = inputs.mach-nix.packages.${prev.system}.mach-nix;

  # workaround broken pyopenssl and twisted InstallCheck phase on darwin
  awscli2 =
    if prev.system == "aarch64-darwin" then
      prev.awscli2.override
        {
          python3 = stable.python310;
        } else prev.awscli2;
  python310 =
    if prev.system == "aarch64-darwin" then
      prev.python310.override
        {
          packageOverrides = self: super: {
            twisted = super.twisted.overrideAttrs (old: {
              doInstallCheck = false;
            });
            pyopenssl = super.pyopenssl.overrideAttrs (old: {
              meta = old.meta // { broken = false; };
            });
          };
        } else prev.python310;

} // import ../pkgs { pkgs = final; prev = prev; }
