{ lib, stdenv, fetchFromGitHub, makeWrapper
, bc, dbus, gawk, gnused, libnotify, pulseaudio }:

let
  path = stdenv.lib.makeBinPath [ bc dbus gawk gnused libnotify pulseaudio ];
  pname = "pulseaudio-ctl";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.68";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wrzfanwy18wyawpg8rfvfgjh3lwngqwmfpi4ww3530rfmi84cf0";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr $out

    substituteInPlace common/${pname}.in \
      --replace '$0' ${pname}
  '';

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${path}
  '';

  meta = with lib; {
    description = "Control pulseaudio volume from the shell or mapped to keyboard shortcuts. No need for alsa-utils";
    homepage = "https://bbs.archlinux.org/viewtopic.php?id=124513";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
