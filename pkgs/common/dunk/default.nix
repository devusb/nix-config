{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, unidiff
, rich
}:

buildPythonPackage rec {
  pname = "dunk";
  version = "0.4.0a0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zXMJ8gLlf26ftiK0kiylbZPezPl67hWQU8cq5Qo/gvI=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    unidiff
    rich
  ];
}
