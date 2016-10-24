{ stdenv, fetchFromGitHub, jdk, jre, maven, pcsclite, makeDesktopItem
, makeWrapper
}:

stdenv.mkDerivation rec {
  appName = "open-ecard";
  version = "1.2.3";
  name = "${appName}-${version}";

  src = fetchFromGitHub {
    owner = "ecsec";
    repo = appName;
    rev = version;
    sha256 = "0qjj3fvyilp3d3xbwmadnwqjjr9ygmak0vnhv5gwlmzyda5fjs7n";
  };

  buildInputs = [ jdk maven makeWrapper ];

  buildPhase = ''
    mvn clean install -Prelease -Dmaven.repo.local=$(pwd)/.m2 \
      -Dsign.keystore=$(pwd)/src/package/resources/keystore/keystore.jks \
      -pl clients/richclient
  '';

  desktopItem = makeDesktopItem {
    name = appName;
    desktopName = "Open eCard App";
    genericName = "eCard App";
    comment = "Client side implementation of the eCard-API-Framework";
    icon = "oec_logo_bg-transparent.svg";
    exec = appName;
    categories = "Utility;Security;";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp clients/richclient/target/richclient-${version}-bundle-cifs.jar \
      $out/share/java

    mkdir -p $out/share/applications $out/share/pixmaps
    cp $desktopItem/share/applications/* $out/share/applications
    cp gui/graphics/src/main/ext/oec_logo_bg-transparent.svg $out/share/pixmaps

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${appName} \
      --add-flags "-jar $out/share/java/richclient-${version}-bundle-cifs.jar" \
      --suffix LD_LIBRARY_PATH ':' ${pcsclite}/lib
  '';

  meta = with stdenv.lib; {
    description = "Client side implementation of the eCard-API-Framework (BSI
      TR-03112) and related international standards, such as ISO/IEC 24727";
    homepage = https://www.openecard.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sephalon ];
    platforms = platforms.linux;
  };
}
