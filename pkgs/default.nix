# When you add custom packages, list them here
{ pkgs, ... }: {
  # helm2 binaries for darwin
  helm2_15_1 = pkgs.callPackage ./darwin/helm2 { version = "2.15.1"; hash = "sha256:0f9ic5cav1nbsgvis891nylqymsj8lcr7g1bvxn9601c3wfk7n2f"; };
  helm2_13_1 = pkgs.callPackage ./darwin/helm2 { version = "2.13.1"; hash = "sha256:0a21xigcblhc9wikl7ilqvs7514ds4x71jz4yv2kvv1zjvdd9i8n"; };
  helm2_16_2 = pkgs.callPackage ./darwin/helm2 { version = "2.16.2"; hash = "sha256:0hqmv2dk15airyihkqzg4x13hndvlff1k7sa1pbr6hgbm8lb6gqh"; };
  helm2_17_0 = pkgs.callPackage ./darwin/helm2 { version = "2.17.0"; hash = "sha256:1kz9a35w8gy97v1qgyq6jr7gfhkqn3hc60xknchabhzxjwm6ypr4"; };

  pgdiff = pkgs.callPackage ./common/pgdiff { buildGoModule = pkgs.buildGo117Module; };

  # sm64ex
  sm64ex-coop = pkgs.callPackage ./linux/sm64ex-coop { };
}
