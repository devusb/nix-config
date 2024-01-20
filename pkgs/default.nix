{ final, prev, ... }:
let
  pkgs = prev;
in
{
  # helm2 binaries
  helm2_15_1 = pkgs.callPackage ./helm2 {
    version = "2.15.1";
    hash = rec {
      x86_64-darwin = "sha256:0f9ic5cav1nbsgvis891nylqymsj8lcr7g1bvxn9601c3wfk7n2f";
      aarch64-darwin = x86_64-darwin;
      x86_64-linux = "sha256:00h6kzig4nmvh7k1wvrwi9cm3ww488jwn0hvqpiqagxp07mfdiw4";
    };
  };
  helm2_13_1 = pkgs.callPackage ./helm2 {
    version = "2.13.1";
    hash = rec {
      x86_64-darwin = "sha256:0a21xigcblhc9wikl7ilqvs7514ds4x71jz4yv2kvv1zjvdd9i8n";
      aarch64-darwin = x86_64-darwin;
      x86_64-linux = "sha256:1wyhyxsm7260wjx9lqzg7vhply52m9yb5mcixifx0q4lq3s2pgp4";
    };
  };
  helm2_16_2 = pkgs.callPackage ./helm2 {
    version = "2.16.2";
    hash = rec {
      x86_64-darwin = "sha256:0hqmv2dk15airyihkqzg4x13hndvlff1k7sa1pbr6hgbm8lb6gqh";
      aarch64-darwin = x86_64-darwin;
      x86_64-linux = "sha256:0xmkdfrnbxziwcq4s1xwjrk15nihcb7adsz05429k99ws3yn1inr";
    };
  };
  helm2_17_0 = pkgs.callPackage ./helm2 {
    version = "2.17.0";
    hash = rec {
      x86_64-darwin = "sha256:1kz9a35w8gy97v1qgyq6jr7gfhkqn3hc60xknchabhzxjwm6ypr4";
      aarch64-darwin = x86_64-darwin;
      x86_64-linux = "sha256:13i29mrhw7vhy1mq08khrcqdzyspic5cabz7h7d2nc2pgxjapf4z";
    };
  };

  # go-plex-client
  go-plex-client = pkgs.callPackage ./go-plex-client { };

  # go-simple-upload-server
  go-simple-upload-server = pkgs.callPackage ./go-simple-upload-server { };

  # pgdiff
  pgdiff = pkgs.callPackage ./pgdiff { };

  # kor
  kor = pkgs.callPackage ./kor { };

  # krr
  krr = pkgs.callPackage ./krr { };

  # vkv
  vkv = pkgs.callPackage ./vkv { };

  # extest
  extest = pkgs.callPackage ./extest { };

  # reposync
  reposync = pkgs.callPackage ./reposync { };

  # JellyPlex-Watched
  jellyplex-watched = pkgs.callPackage ./jellyplex-watched { };

  # sunshine
  sunshine-unstable = pkgs.callPackage ./sunshine { };

  # kde-rounded-corners
  kde-rounded-corners = pkgs.qt6Packages.callPackage ./kde-rounded-corners { kwin = final.kde2nix.kwin; kcmutils = final.kde2nix.kcmutils; };

  # python packages
  pythonPackagesExtensions = pkgs.pythonPackagesExtensions ++ [
    (
      self: super: {
        # timedb
        pypika = pkgs.python3Packages.callPackage ../pkgs/pypika { };
        timedb = pkgs.python3Packages.callPackage ../pkgs/timedb { };

      }
    )
  ];

}
