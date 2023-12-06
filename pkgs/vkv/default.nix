{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vkv";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "0cc6b7000e3aae02d0e4e040213e89ffa1665b28";
    hash = "sha256-GQv6R6hNMVtQ01AgK6YkGP51l7UCcByhdEg+If2/1wE=";
  };

  vendorHash = "sha256-BJEbxjy0/SU8fvQaCGpTQZB04WR0VfWMEne1ABZeY44=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  checkFlags = [
    # requires docker
    "-skip=TestVaultSuite"
  ];

  meta = with lib; {
    description = "vkv enables you to list, compare, import, document, backup & encrypt secrets from a HashiCorp Vault KV-v2 engine";
    homepage = "https://github.com/FalcoSuessgott/vkv";
    license = licenses.mit;
    mainProgram = "vkv";
  };
}
