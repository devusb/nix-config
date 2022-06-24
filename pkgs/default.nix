# When you add custom packages, list them here
{ pkgs }: {
  helm2_15_1 = pkgs.callPackage ./helm2 { version = "2.15.1"; };
  helm2_13_1 = pkgs.callPackage ./helm2 { version = "2.13.1"; };
  helm2_16_2 = pkgs.callPackage ./helm2 { version = "2.16.2"; };
  aws-sso-cli = pkgs.callPackage ./aws-sso-cli {};
}
