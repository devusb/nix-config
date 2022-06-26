{ lib, stdenv, buildGoPackage, fetchFromGitHub, version ? "2.15.1" }:

buildGoPackage rec {
  inherit version;
  pname = "helm";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "1afbymgpax7kgjjv1c9xb4dm7gcrhn2g69piamdq1k0ng348k5w0";
  };

  goPackagePath = "k8s.io/helm";
  subPackages = [ "cmd/helm" "cmd/tiller" "cmd/rudder" ];

  goDeps = ./deps.nix;

  # Thsese are the original flags from the helm makefile
  ldflags = [ "-X k8s.io/helm/pkg/version.Version=v${version}" "-X k8s.io/helm/pkg/version.GitTreeState=clean" "-X k8s.io/helm/pkg/version.BuildMetadata=" "-w" "-s" ];

  preBuild = ''
    # This is a hack(?) to flatten the dependency tree the same way glide or dep would
    # Otherwise you'll get errors like
    # have DeepCopyObject() "k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/runtime".Object
    # want DeepCopyObject() "k8s.io/apimachinery/pkg/runtime".Object
    rm -rf $NIX_BUILD_TOP/go/src/k8s.io/kubernetes/vendor
    rm -rf $NIX_BUILD_TOP/go/src/k8s.io/apiextensions-apiserver/vendor
  '';

  postInstall = ''
    mv $out/bin/helm $out/bin/helm${version}
    mv $out/bin/rudder $out/bin/rudder${version}
    mv $out/bin/tiller $out/bin/tiller${version}
  '';

  meta = with lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
  };
}
