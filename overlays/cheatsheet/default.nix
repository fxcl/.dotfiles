{ stdenv, fetchurl, undmg, zip, unzip }:

stdenv.mkDerivation rec {
  pname = "cheatsheet";
  version = "1.6";

  buildInputs = [ zip unzip ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      mkdir -p "$out/Applications"
      cp -r CheatSheet.app "$out/Applications/CheatSheet.app"
    '';

  src = fetchurl {
    name = "Cheatsheet-${version}.zip";
    url = "https://mediaatelier.com/CheatSheet/CheatSheet_${version}.zip";
    sha256 = "1x4h46gpg79g2mslwzhfw15nzsjfs6g3fwf7g11n9mj4ixlnz634";
  };

  meta = with stdenv.lib; {
    description = "CheatSheet - Know your shortcuts";
    homepage = "https://www.sketch.com/";
    maintainers = [ maintainers.fxcl ];
    platforms = platforms.darwin;
  };
}
