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
, pbr
}:

buildPythonPackage rec {
  pname = "timedb";
  rev = "ba4dc0600890d27478fc78b9b2a18f4e21c139b7";
  version = "3.37.1+${builtins.substring 0 7 rev}";

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
