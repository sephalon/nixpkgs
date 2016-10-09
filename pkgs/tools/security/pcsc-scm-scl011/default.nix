{ stdenv, fetchurl, libusb, p7zip }:

stdenv.mkDerivation rec {
  name = "pcsc-scm-scl-${version}";
  version = "2.09";

  src = fetchurl {
    url = http://download.javacardsdk.com/scl011g_2v09_linux_driver.rar;
    sha256 = "10vhrzza4p2pvxfs4danypw0jd8m4ncf86lfgr343pkqa5c1nswr";
  };

  buildInputs = [ p7zip ];

  unpackPhase = ''
    7z x $src
    tar xf SCL_generic_linux_64bit_driver_V${version}.tar.gz
    cd sclgeneric_${version}_linux_64bit; export sourceRoot=`pwd`
  '';

  patches = [ ./eid.patch ];

  installPhase = ''
    mkdir -p $out/pcsc/drivers
    cp -r proprietary/*.bundle $out/pcsc/drivers
  '';

  libPath = stdenv.lib.makeLibraryPath [ libusb ];

  fixupPhase = "patchelf --set-rpath $libPath $out/pcsc/drivers/SCLGENERIC.bundle/Contents/Linux/libSCLGENERIC.so.${version}";

  meta = with stdenv.lib; {
    description = "SCM Microsystems SCL011 chipcard reader user space driver";
    homepage = http://www.scm-pc-card.de/index.php?lang=en&page=product&function=show_product&product_id=630;
    downloadPage = http://download.javacardsdk.com/SCL011.htm;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ sephalon ];
    platforms = platforms.linux;
  };
}
