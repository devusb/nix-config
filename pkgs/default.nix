# When you add custom packages, list them here
{ pkgs, prev }: {
  helm2_15_1 = pkgs.callPackage ./common/helm2 { version = "2.15.1"; };
  helm2_13_1 = pkgs.callPackage ./common/helm2 { version = "2.13.1"; };
  helm2_16_2 = pkgs.callPackage ./common/helm2 { version = "2.16.2"; };
  brave = if prev.system == "aarch64-darwin" then prev.callPackage ./darwin/brave {} else prev.brave;
}
