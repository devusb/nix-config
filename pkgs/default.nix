# When you add custom packages, list them here
{ pkgs }: {
  helm2 = pkgs.callPackage ./helm2 { };
}
