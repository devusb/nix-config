{ fetchFromGitHub
, fetchPypi
, python3
, fetchpatch
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
  prometrix = python3.pkgs.buildPythonPackage rec {
    pname = "prometrix";
    version = "0.1.12";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-QzFxOAx4Un0TRXdpgiMA9uZR/5jBXhxy4TrLWXterOw=";
    };
    propagatedBuildInputs = with python3.pkgs; [
      pandas
      numpy
      dateparser
      matplotlib
      httmock
      requests
      poetry-core
      boto3
      botocore
      prometheus-api-client
      pydantic_1
    ];
    doCheck = false;
    nativeBuildInputs = with python3.pkgs; [
      pythonRelaxDepsHook
    ];

    pythonRelaxDeps = true;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "robusta_krr";
  version = "unstable-2023-11-06";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    rev = "952fd37a489b4cea9512e51793023d0d20116e4b";
    sha256 = "sha256-C/WfE0/SR1BFHY+aW/jC08iy/MZnwkXwQ2KFQUrsIn0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    poetry-core
    pydantic_1
    numpy
    pandas
    cachetools
    kubernetes
    typer
    about-time
    alive-progress
    prometheus-api-client
    prometrix
    rich
    aiostream
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
    slack-sdk
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
