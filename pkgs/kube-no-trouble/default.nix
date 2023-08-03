{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kube-no-trouble";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    hash = "sha256-QIvMhKAo30gInqJBpHvhcyjgVkdRqgBKwLQ80ng/75U=";
  };

  vendorHash = "sha256-XXf6CPPHVvCTZA4Ve5/wmlgXQ/gZZUW0W/jXA0bJgLA=";

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your clusters for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "kubent";
  };
}
