{ lib
, buildPythonPackage
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
, pip
}:

buildPythonPackage rec {
  pname = "timedb";
  version = "3.37.1+19de890";

  src = fetchGit {
    url = "git@imugit.imubit.com:imubit-dlpc/product/timedb.git";
    rev = "19de8900752f67bfd9b325996c86ab4977e28dc8";
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
    pip
  ];
  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = true;
  pythonRemoveDeps = [ "psycopg2-binary" ];

  postPatch = ''
    substituteInPlace setup.py \
    --replace "import versioneer" "" \
    --replace "versioneer.get_version()" "'${version}'" \
  '';

  doCheck = false;

  meta = { };
}
