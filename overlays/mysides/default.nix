{ lib, stdenv, fetchurl, libarchive, p7zip }:
with lib;

stdenv.mkDerivation rec {
  pname = "mysides";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/mosen/mysides/releases/download/v${version}/mysides-${version}.pkg";
    sha256 = "sha256-dpRrj3xb9xQSXXXxragUDgNPBaniiMc6evRF12wqVRQ=";
  };

  dontBuild = true;
  nativeBuildInputs = [ libarchive p7zip ];

  unpackPhase = ''
    7z x $src
    bsdtar -xf Payload~
  '';

  installPhase = ''
    mkdir -pv $out/bin
    cp "usr/local/bin/mysides" "$out/bin/mysides"
  '';

  meta = {
    description = "Manage macOS Finder sidebar favorites";
    homepage = "https://github.com/mosen/mysides";
    license = licenses.mit;
    maintainers = [ "tboerger" ];
    platforms = platforms.darwin;
  };
}
