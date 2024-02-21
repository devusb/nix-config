{ buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "PyPika";
  version = "0.48.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g4g2phdH58g4DNG3/2OGlLenM1NF0PVZsEss2DKtU3g=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = true;

  doCheck = false;

  meta = { };
}
