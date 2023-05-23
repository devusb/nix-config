{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, pythonRelaxDepsHook
, poetry-core
, pydantic
, numpy
, pandas
, cachetools
, kubernetes
, typer
, grapheme
, certifi
, charset-normalizer
, click
, colorama
, commonmark
, contourpy
, cycler
, dateparser
, fonttools
, google-auth
, httmock
, idna
, importlib-resources
, kiwisolver
, matplotlib
, oauthlib
, packaging
, pillow
, pyasn1
, pyasn1-modules
, pygments
, pyparsing
, python-dateutil
, pytz-deprecation-shim
, pytz
, pyyaml
, regex
, requests-oauthlib
, requests
, rich
, rsa
, setuptools
, shellingham
, six
, typing-extensions
, tzdata
, tzlocal
, urllib3
, websocket-client
, zipp
}:

let
  about-time = buildPythonPackage rec {
    pname = "about-time";
    version = "4.2.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-alOIYtM85n2ZdCnRSZgxDh2/2my32bv795nEcJhH/s4=";
    };
    doCheck = false;
  };
  alive-progress = buildPythonPackage rec {
    pname = "alive-progress";
    version = "3.1.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-siupYBUfWCzdbUicVkYtL5rcqCFggHXQ2NLNFdG2hFs=";
    };
    propagatedBuildInputs = [
      pythonRelaxDepsHook
      about-time
      grapheme
    ];
    doCheck = false;
  };
  prometheus-api-client = buildPythonPackage rec {
    pname = "prometheus-api-client";
    version = "0.5.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-mywpPCAgcuXPZxmanMQdXrMvAt2MwjxYR7YDzZzpm88=";
    };
    propagatedBuildInputs = [
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
buildPythonPackage rec {
  pname = "krr";
  version = "1.0.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    rev = "v${version}";
    sha256 = "sha256-LaSbSbh13bcQwxWXZ7RlddPqmMbte8Vf69M5Ms/BaJE=";
  };

  propagatedBuildInputs = [
    pythonRelaxDepsHook
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

  pythonRelaxDeps = true;

  doCheck = false;

  meta = { };
}
