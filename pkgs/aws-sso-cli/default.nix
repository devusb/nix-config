
  { buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    sha256 = "9/dZfRmFAyE5NEMmuiVsRvwgqQrTNhXkTR9N0d3zgfk=";
  };

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard.";
    license = licenses.gpl3;
  };
}