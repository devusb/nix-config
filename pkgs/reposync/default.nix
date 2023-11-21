{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "reposync";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Zextras";
    repo = "reposync";
    rev = version;
    hash = "sha256-g70TycPwMHoi4mAMCdM81IXUz1tf5PhtUgpngF48zo4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "A tool to sync Debian and RedHat repositories with S3";
    homepage = "https://github.com/Zextras/reposync";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "reposync";
  };
}
