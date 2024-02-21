{ buildPythonPackage
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
, pbr
}:

buildPythonPackage rec {
  pname = "timedb";
  rev = "f9c05773c605d0a66cb115c786c054a8cb6bdbf5";
  version = "3.38.0";

  src = fetchGit {
    url = "git@imugit.imubit.com:imubit-dlpc/product/timedb.git";
    inherit rev;
    allRefs = true;
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
    pbr
  ];
  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = true;

  postPatch = ''
    substituteInPlace setup.py \
    --replace "import versioneer" "" \
    --replace "versioneer.get_version()" "'${version}'" \
  '';

  doCheck = false;

  meta = { };
}
