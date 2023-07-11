{ lib
, buildPythonPackage
, fetchurl
, pythonRelaxDepsHook
, psycopg2
, pandas
, numpy
, six
, pypika
, yoyo-migrations
, docopt
, pytimeparse
, packaging
}:

buildPythonPackage rec {
  pname = "timedb";
  version = "3.37.1";
  format = "wheel";

  src = fetchurl {
    inherit pname version;
    url = "http://10.10.30.245:8081/repository/pypi-stable/packages/${pname}/${version}/${pname}-${version}-py2.py3-none-any.whl";
    sha256 = "sha256-pEntL45c7gcNavHUahNfH2DcdkrkYu4SVImX0xTNsdo=";
  };

  propagatedBuildInputs = [
    psycopg2
    pandas
    numpy
    six
    pypika
    yoyo-migrations
    docopt
    pytimeparse
    packaging
  ];
  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = true;
  pythonRemoveDeps = [ "psycopg2-binary" ];

  dontUseWheelUnpack = true;
  unpackPhase = ''
    mkdir dist
    cp $src dist/${pname}-${version}-py2.py3-none-any.whl
    chmod +w dist
  '';

  doCheck = false;

  meta = { };
}
