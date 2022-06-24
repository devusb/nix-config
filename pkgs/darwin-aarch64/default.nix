# When you add custom packages, list them here
{ pkgs }: {
  brave = pkgs.callPackage ./brave {};
}
