{ stdenv, fetchFromGitHub
, cmake, pkg-config
, libva, libpciaccess, intel-gmmlib
, enableX11 ? true, libX11
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  version = "20.4.5";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    rev    = "intel-media-${version}";
    sha256 = "149xkhhp8q06c1jzxjs24lnbfrlvf19m0hcwld593vv4arfpbpmf";
  };

  cmakeFlags = [
    "-DINSTALL_DRIVER_SYSCONF=OFF"
    "-DLIBVA_DRIVERS_PATH=${placeholder "out"}/lib/dri"
    # Works only on hosts with suitable CPUs.
    "-DMEDIA_RUN_TEST_SUITE=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libva libpciaccess intel-gmmlib ]
    ++ stdenv.lib.optional enableX11 libX11;

  meta = with stdenv.lib; {
    description = "Intel Media Driver for VAAPI — Broadwell+ iGPUs";
    longDescription = ''
      The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API)
      user mode driver supporting hardware accelerated decoding, encoding, and
      video post processing for GEN based graphics hardware.
    '';
    homepage = "https://github.com/intel/media-driver";
    changelog = "https://github.com/intel/media-driver/releases/tag/intel-media-${version}";
    license = with licenses; [ bsd3 mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos jfrankenau ];
  };

  postFixup = stdenv.lib.optionalString enableX11 ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/lib/dri/iHD_drv_video.so):${stdenv.lib.makeLibraryPath [ libX11  ]}" \
      $out/lib/dri/iHD_drv_video.so
  '';
}
