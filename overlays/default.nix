{ inputs, ... }: final: prev: rec {
  stable = import inputs.nixpkgs-stable { system = prev.system; };
  mpack = inputs.mpack.packages.${prev.system}.mpack;
  mach-nix = inputs.mach-nix.packages.${prev.system}.mach-nix;

  # workaround broken pyopenssl and twisted InstallCheck phase on darwin
  awscli2 = prev.awscli2.override { python3 = stable.python39; };
  python39 = prev.python39.override {
    packageOverrides = self: super: {
      twisted = super.twisted.overrideAttrs (old: {
        doInstallCheck = false;
      });
      pyopenssl = super.pyopenssl.overrideAttrs (old: {
        meta = old.meta // { broken = false; };
      });
    };
  };

} // import ../pkgs { pkgs = final; }