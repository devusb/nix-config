{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kube-no-trouble";
  version = "unstable-2023-05-05";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "df9a0174afa2f13cee0c3f5bcc3bf3421166b57d";
    hash = "sha256-9moDISLgWUk1PzZbHdkgVrIfjFhtJq/hCOA0t38VznY=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-5w8WE6gcAz+ZBtx2KHaORa78pe3jba5gFwGcJJY0XZA=";

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your clusters for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "kubent";
  };
}
