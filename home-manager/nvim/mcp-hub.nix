{ pkgs }:

pkgs.buildNpmPackage rec {
  pname = "mcp-hub";
  version = "4.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcp-hub";
    rev = "v${version}";
    hash = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg="; # will need new real hash — version changed
  };

  npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g="; # will need new real hash too — deps likely changed
}
