with (import <nixpkgs>) {
  config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };
};
let
  androidComposition = androidenv.composeAndroidPackages {
    platformVersions = [ "33" ];
    includeNDK = true;
    ndkVersion = "21.4.7075529";
    abiVersions = [ "x86_64" ];
  };
  androidSdk = androidComposition.androidsdk;
  ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
in
stdenv.mkDerivation {
  name = "Telegram FOSS dependencies builder";

  buildInputs = [
    androidSdk
    ninja
    go
    cmake
    yasm
    apksigner
  ];

  inherit ANDROID_NDK_ROOT;
  inherit ANDROID_SDK_ROOT;
  NDK = ANDROID_NDK_ROOT;
  NINJA_PATH = "${ninja}/bin/ninja";
}
