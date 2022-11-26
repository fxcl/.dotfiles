{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "99.0.1";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "sha256-GLilNbniL4WYey63baEit0al2S6RPnCrOnp8q39PaaA";
  };

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    license = licenses.mpl20;
    maintainers = [];
    platforms = platforms.darwin;
  };

}
