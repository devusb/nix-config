# When you add custom packages, list them here
{ pkgs, ... }: {
  # I think these are all actually 2.15.1 due to identical hash but claim to be other versions due to ldflags ... but they work for my purposes anyway.
  helm2_15_1 = pkgs.callPackage ./common/helm2 { version = "2.15.1"; buildGoPackage = pkgs.buildGo117Package; };
  helm2_13_1 = pkgs.callPackage ./common/helm2 { version = "2.13.1"; buildGoPackage = pkgs.buildGo117Package; };
  helm2_16_2 = pkgs.callPackage ./common/helm2 { version = "2.16.2"; buildGoPackage = pkgs.buildGo117Package; };
  helm2_17_0 = pkgs.callPackage ./common/helm2 { version = "2.17.0"; buildGoPackage = pkgs.buildGo117Package; };

  pgdiff = pkgs.callPackage ./common/pgdiff { buildGoModule = pkgs.buildGo117Module; };

  # sm64ex
  sm64ex-coop = pkgs.callPackage ./linux/sm64ex-coop { };
}
