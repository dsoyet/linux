{ lib, stdenv, fetchurl, autoPatchelfHook, fuse3, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ossfs2";
  version = "2.0.8";

  src = fetchurl {
    url = "https://gosspublic.alicdn.com/ossfs/ossfs2_${version}_linux_x86_64.rpm";
    hash = "sha256-ed8979466dc3a95d5c9a10893eba1b0368034ab19d050fa47b08b0e3dc417112";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ fuse3 ];

  unpackPhase = ''
    bsdtar -xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp usr/local/bin/ossfs2 $out/bin/
    ln -s ossfs2 $out/bin/mount.ossfs2
  '';

  meta = with lib; {
    description = "High-performance FUSE client to mount Alibaba Cloud OSS buckets";
    homepage = "https://www.alibabacloud.com/help/en/oss/developer-reference/ossfs-2-0";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ossfs2";
  };
}
