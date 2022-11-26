{ lib, stdenv, fetchurl, libarchive, p7zip }:
with lib;

stdenv.mkDerivation rec {
  pname = "dockutil";
  version = "3.0.2";
  versions = "3.0.2";

  src = fetchurl {
    url = "https://github.com/kcrawford/dockutil/releases/download/${version}/dockutil-${versions}.pkg";
    sha256 = "sha256-F1E36nR+g+0iHWCxi3ErJW7TFTFTTN6E9nlIfTN2aP0=";
  };

  dontBuild = true;
  nativeBuildInputs = [ libarchive p7zip ];

  unpackPhase = ''
    7z x $src
    bsdtar -xf Payload~
  '';

  installPhase = ''
    #mkdir -pv $out/bin
    #cp "usr/local/bin/dockutil" "$out/bin/dockutil"

    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/usr/local/bin
    install -Dm755 usr/local/bin/dockutil -t $out/usr/local/bin
    ln -rs $out/usr/local/bin/dockutil $out/bin/dockutil
    runHook postInstall

  '';

  meta = {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    maintainers = [ "zxfstd" ];
    platforms = platforms.darwin;
  };
}
