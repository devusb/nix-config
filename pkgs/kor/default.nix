{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kor";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-+MP1kxyB53VXlNtQWMDW9CJmWWzqWKkm5I+6aPwBdWE=";
  };

  vendorHash = "sha256-wmRu3uA3AmewJxzKhDNcCHEVHeAKR7jDGGdWgMN//n0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A Tool to discover unused Kubernetes Resouorces";
    homepage = "https://github.com/yonahd/kor";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
  };
}
