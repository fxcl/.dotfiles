{ lib, stdenv, fetchurl, undmg }:
with lib;

stdenv.mkDerivation rec {
  pname = "chrome";
  version = "stable";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Google\ Chrome.app "$out/Applications/Google Chrome.app"
  '';

  src = fetchurl {
    name = "Chrome-${version}.dmg";
    url = "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg";
    sha256 = "sha256-JdrKmO2TmPxNmX6XPyqD9Pxgpj3bcZIm+fH82udFHPg=";
  };

  meta = {
    description = "The browser built by Google";
    homepage = "https://www.google.com/chrome/";
    maintainers = [ maintainers.zxfstd ];
    platforms = platforms.darwin;
  };
}
