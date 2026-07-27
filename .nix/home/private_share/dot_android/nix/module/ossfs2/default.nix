{ pkgs }:

let
  inherit (pkgs) lib stdenv fetchurl libarchive makeWrapper;
in
stdenv.mkDerivation rec {
  pname = "ossfs2";
  version = "2.0.8";

  src = fetchurl {
    url = "https://gosspublic.alicdn.com/ossfs/ossfs2_${version}_linux_x86_64.rpm";
    hash = "sha256-7Yl5Rm3DqV1cmhCJProbA2gDSrGdBQ+kewiw49xBcRI=";
  };

  nativeBuildInputs = [ libarchive makeWrapper ];

  unpackPhase = ''
    bsdtar -xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/ossfs2
    cp usr/local/bin/ossfs2 $out/bin/
    ln -s ossfs2 $out/bin/mount.ossfs2
    cp usr/local/lib64/ossfs2/libfuse3.so.3 $out/lib/ossfs2/

    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
             --set-rpath $out/lib/ossfs2 \
             $out/bin/ossfs2
  '';

  meta = with lib; {
    description = "High-performance FUSE client to mount Alibaba Cloud OSS buckets";
    homepage = "https://www.alibabacloud.com/help/en/oss/developer-reference/ossfs-2-0";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ossfs2";
  };
}
