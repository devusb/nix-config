{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgdiff";
  version = "1.0b1";
  rev = "2156eaecb0d4c5f1d7cb49a6db90467ec93a1fda";

  src = fetchFromGitHub {
    inherit rev;
    owner = "joncrlsn";
    repo = "pgdiff";
    sha256 = "sha256-LCpDcCV40AqPnRNnLxQUUc2SW9ULyrDNg51XrfRPX6A=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-rDuO6SfDOgocCdbMbkL23LJeDFqnWTwnTTp+JofOHos=";

  meta = {
    license = lib.licenses.mit;
  };
}
