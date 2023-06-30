{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgdiff";
  version = "1.0b1";
  rev = "3e91a5abe4b1954190aeefbade7d7aed9443b5ef";

  src = fetchFromGitHub {
    inherit rev;
    owner = "devusb";
    repo = "pgdiff";
    sha256 = "sha256-8qZdcORiGnJexj0rU7sgvl2ArwmIYo8aMl3uTw2O0Bw=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-sbVEGv+EY80gMP/WJFBE+lwsy1MHRFe4KfPWn/wlPZQ=";

  meta = {
    license = lib.licenses.mit;
  };
}
