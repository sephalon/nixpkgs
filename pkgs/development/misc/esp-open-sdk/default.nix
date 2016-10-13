{ fetchgit, autoconf, stdenv, git,
  help2man, lib, makeWrapper, fetchurl, writeScript
, gcc, m4, perl, which, gperf, bison, flex, texinfo, wget, libtool, automake
, ncurses, file, unzip, python, expat}:

stdenv.mkDerivation rec {
  rev = "89ecaadb99e6006644da7635cd447007090d2fca";
  name = "esp-open-sdk-${rev}";

cg-ng-esp = import ./crosstool-ng-esp {
  inherit fetchgit autoconf help2man stdenv lib makeWrapper fetchurl writeScript
 gcc m4 perl which gperf bison flex texinfo wget libtool automake
 ncurses file unzip python expat;

};


  src = fetchgit {
    url = "https://github.com/pfalcon/esp-open-sdk";
    rev = rev;
    sha256 = "04yzmr7zp1f3i3ixxrcr63ywq515b05yjzfba8s0rrabla6vdzkp";
    deepClone = true;
  };

  # GCC won't build otherwise
  hardeningDisable = [ "format" ];

  patches = [ ./crosstool-NG.patch ];

  buildInputs = [ autoconf cg-ng-esp ];

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
