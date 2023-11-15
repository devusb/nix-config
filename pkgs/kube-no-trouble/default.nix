{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kube-no-trouble";
  version = "nightly-0.7.0-58-g270c9cb";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    hash = "sha256-wqlnZg/qzlGlOvwx/0kuehPi4X5mTeDWDfmQ/ecKQbw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-nEc0fngop+0ju8hDu7nowBsioqCye15Jo1mRlM0TtlQ=";

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your clusters for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "kubent";
  };
}
