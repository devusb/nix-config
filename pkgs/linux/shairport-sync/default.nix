{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, avahi
, alsa-lib
, glib
, libdaemon
, popt
, libconfig
, libpulseaudio
, soxr
, libplist
, unixtools
, libsodium
, libgcrypt
, ffmpeg
, libuuid
, enableDbus ? stdenv.isLinux
, enableMetadata ? false
, enableMpris ? stdenv.isLinux
}:

with lib;
stdenv.mkDerivation rec {
  version = "4.1.1-dev";
  pname = "shairport-sync";

  src = fetchFromGitHub {
    sha256 = "sha256-7nCSXx6zmrlYj6Qwfze5rkjMG0D7Q1EnwA3mtQsXy7g=";
    rev = "a6c66db2761619456e80611d2ffc6054684f9caf";
    repo = "shairport-sync";
    owner = "mikebrady";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    openssl
    avahi
    alsa-lib
    libdaemon
    popt
    libconfig
    libpulseaudio
    soxr
    unixtools.xxd
    libplist
    libsodium
    libgcrypt
    ffmpeg
    libuuid
  ] ++ optional stdenv.isLinux glib;

  prePatch = ''
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' dbus-service.c
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' mpris-service.c
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-alsa"
    "--with-pipe"
    "--with-pa"
    "--with-stdout"
    "--with-avahi"
    "--with-ssl=openssl"
    "--with-soxr"
    "--with-airplay-2"
    "--without-configfiles"
    "--sysconfdir=/etc"
  ]
  ++ optional enableDbus "--with-dbus-interface"
  ++ optional enableMetadata "--with-metadata"
  ++ optional enableMpris "--with-mpris-interface";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
    platforms = platforms.unix;
  };
}
