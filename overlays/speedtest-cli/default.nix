{ stdenv, fetchzip,fetchurl, undmg, zip, unzip }:

stdenv.mkDerivation rec {
  pname = "speedtest";
  version = "1.0.0";

  buildInputs = [ zip unzip ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      ls

      mkdir -p "$out/bin"
      cp ./speedtest "$out/bin/speedtest"
    '';

  src = fetchurl {
    url = "https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-macosx.tgz";
    sha256 = "1x78lmq6nkkd745cvgczgs3k2qcp2qq1fvv7nw2bz3v63slgh2ld";
  };

  meta = with stdenv.lib; {
    description = "Sketch - The Digital Design toolki";
    homepage = "https://www.sketch.com/";
    maintainers = [ maintainers.fxcl ];
    platforms = platforms.darwin;
  };
}
