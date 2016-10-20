{ stdenv, lib, makeWrapper, fetchgit, fetchurl, writeScript, git
, help2man, gcc, m4, perl, which, gperf, bison, flex, texinfo, wget, libtool
, ncurses, file, unzip, python, expat, autoconf, automake
}:

stdenv.mkDerivation rec {
  rev = "24f10eb164947fdd38b6225f72e752d5eb785391";
  name = "esp-open-sdk-${rev}";

  src = fetchgit {
    url = "https://github.com/pfalcon/esp-open-sdk";
    rev = rev;
    sha256 = "1ssklx9r2rwd364hl5gwb7jhk7apw3gk39h8qbs0hgjhci7nrqzv";
    deepClone = true;
  };

  cg-ng-esp = import ./crosstool-ng-esp {
    inherit stdenv lib makeWrapper fetchgit fetchurl writeScript
    gcc m4 perl which gperf bison flex texinfo wget libtool automake
    ncurses file unzip python expat autoconf help2man;
    sdkRev = rev;
  };

  buildInputs = [ autoconf cg-ng-esp ];

  # GCC won't build otherwise
  hardeningDisable = [ "format" ];

  patches = [ ./crosstool-NG.patch ];

  installPhase = ''
    mkdir -p $out
    cp -r xtensa-lx106-elf $out
    cp -Lr sdk $out
  '';

  meta = with stdenv.lib; {
    description = "Free and open (as much as possible) integrated SDK for ESP8266 chips";
    homepage = https://github.com/pfalcon/esp-open-sdk;
    license = licenses.free;
    maintainers = [ maintainers.sephalon ];
    platforms = platforms.linux;
  };
}
