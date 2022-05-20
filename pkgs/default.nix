# When you add custom packages, list them here
{ pkgs }: {
  helm2 = pkgs.callPackage ./helm2 {};
  aws-sso-cli = pkgs.callPackage ./aws-sso-cli {};
}
