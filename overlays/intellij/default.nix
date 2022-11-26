{ lib, stdenv, fetchurl, undmg }:
with lib;

stdenv.mkDerivation rec {
  pname = "intellij-idea-ce";
  version = "2021.3.2";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out/Applications
    cp -r "IntelliJ IDEA CE.app" $out/Applications/IDEA.app
  '';

  src = fetchurl {
    name = "intellij-idea-ce-${version}.dmg";
    url = "https://download.jetbrains.com/idea/ideaIC-${version}.dmg";
    sha256 = "1sfkzv4hgg6qq859hklxwmcmpjlfs09mwycg73mb1bpdpgicxn10";
  };

  meta =  {
    description = "Intellij IDEA Community Edition";
    homepage = "https://www.jetbrains.com/idea/";
    maintainers = [];
    platforms = platforms.darwin;
  };
}
