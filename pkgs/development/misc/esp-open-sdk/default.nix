{ stdenv, lib, makeWrapper, fetchgit, fetchurl, writeScript, git
, help2man, gcc, m4, perl, which, gperf, bison, flex, texinfo, wget, libtool
, ncurses, file, unzip, python, expat, autoconf, automake
}:

stdenv.mkDerivation rec {
  rev = "3701f042eda49989a3f33e4ea3f2d099817f1e2d";
  name = "esp-open-sdk-${rev}";

  src = fetchgit {
    url = "https://github.com/pfalcon/esp-open-sdk";
    rev = rev;
    sha256 = "1zngj05mvpiqvkvdcbz9sv3qq3kjwkqyqkalyq8r9hxvb1lzc5qi";
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
