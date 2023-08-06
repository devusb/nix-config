{ lib
, fetchFromGitHub
, fetchPypi
, python3
}:

let
  about-time = python3.pkgs.buildPythonPackage rec {
    pname = "about-time";
    version = "4.2.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-alOIYtM85n2ZdCnRSZgxDh2/2my32bv795nEcJhH/s4=";
    };
    doCheck = false;
  };
  alive-progress = python3.pkgs.buildPythonPackage rec {
    pname = "alive-progress";
    version = "3.1.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-siupYBUfWCzdbUicVkYtL5rcqCFggHXQ2NLNFdG2hFs=";
    };
    propagatedBuildInputs = with python3.pkgs; [
      pythonRelaxDepsHook
      about-time
      grapheme
    ];
    doCheck = false;
  };
  prometheus-api-client = python3.pkgs.buildPythonPackage rec {
    pname = "prometheus-api-client";
    version = "0.5.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-mywpPCAgcuXPZxmanMQdXrMvAt2MwjxYR7YDzZzpm88=";
    };
    propagatedBuildInputs = with python3.pkgs; [
      pandas
      numpy
      dateparser
      matplotlib
      httmock
      requests
    ];
    doCheck = false;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "robusta_krr";
  version = "1.0.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    rev = "v${version}";
    sha256 = "sha256-LaSbSbh13bcQwxWXZ7RlddPqmMbte8Vf69M5Ms/BaJE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    poetry-core
    pydantic
    numpy
    pandas
    cachetools
    kubernetes
    typer
    about-time
    alive-progress
    prometheus-api-client
    rich
    certifi
    charset-normalizer
    click
    colorama
    commonmark
    contourpy
    cycler
    fonttools
    google-auth
    idna
    importlib-resources
    kiwisolver
    oauthlib
    packaging
    pillow
    pyasn1
    pyasn1-modules
    pygments
    pyparsing
    python-dateutil
    pytz
    pytz-deprecation-shim
    pyyaml
    regex
    requests-oauthlib
    rsa
    setuptools
    shellingham
    six
    typing-extensions
    tzdata
    tzlocal
    urllib3
    websocket-client
    zipp
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  doCheck = false;

  meta = {
    mainProgram = "krr";
  };
}
