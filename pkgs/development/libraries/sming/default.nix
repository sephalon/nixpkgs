{ stdenv, fetchgit, esp-open-sdk }:

stdenv.mkDerivation rec {
  rev = "5d2158a046deccfad89a4a643dc5e1e0ddcb3fff";
  name = "sming-${rev}";

  src = fetchgit {
    url = https://github.com/SmingHub/Sming.git;
    rev = rev;
    sha256 = "07fvk3p2s5afnz0sz8bsvv0zl41z5jahj18akrd5b7w6hyzcwsj2";
  };

  buildInputs = [ esp-open-sdk ];

  enableParallelBuilding = true;

  preBuild = "cd Sming";
  makeFlags = "ESP_HOME=${esp-open-sdk}";
  postBuild = ''
    make spiffy
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  meta = with stdenv.lib; {
    description = "Open Source framework for high efficiency native ESP8266
      development";
    homepage = https://github.com/SmingHub/Sming;
    license = licenses.lgpl3;
    maintainers = [ maintainers.sephalon ];
    platforms = platforms.linux;
  };
}
