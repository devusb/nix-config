{ buildGoModule, fetchFromGitHub, gnupg, lib }:
buildGoModule rec {
  pname = "cmdg";
  version = "1.02";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "master";
    sha256 = "sha256-XzZtV01yrQTU+NTrC6cb9T2RkN085sd9TA1efb39F40=";
  };
  vendorSha256 = "sha256-GNGuJDtH6fwxOUY1igDueLRUJcVHXOfaSmgBvRVSReg=";

  checkInputs = [ gnupg ];

  meta = with lib; {
    homepage = "https://github.com/ThomasHabets/cmdg";
    description = "cmdg is a commandline client to GMail that provides a UI more similar to Pine/Alpine.";
    license = licenses.gpl3;
  };
}
