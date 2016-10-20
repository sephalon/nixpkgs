{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  rev = "ec0e2c72952f4fa8242eedd307c58a479d845abe";
  name = "esptool2-${rev}";

  src = fetchgit {
    url = "https://github.com/raburton/esptool2.git";
    rev = rev;
    sha256 = "0hd96wamlf8aryvckvcmfkp8j53rwdjjndj8dh35a4ixg5krny32";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp esptool2 $out/bin
  '';

  meta = with stdenv.lib; {
    description = " An ESP8266 rom creation tool";
    homepage = https://github.com/raburton/esptool2;
    license = licenses.gpl3;
    maintainers = [ maintainers.sephalon ];
    platforms = platforms.linux;
  };
}
