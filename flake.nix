{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
        system = "x86_64-linux";
      };

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "33" ];
        includeNDK = true;
        ndkVersion = "21.4.7075529";
        abiVersions = [ "x86_64" ];
      };

      androidSdk = androidComposition.androidsdk;
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
      ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
    in
    {
      packages.x86_64-linux.default = pkgs.clangStdenv.mkDerivation rec {
        name = "Telegram FOSS dependencies builder";
        version = "v10.14.3";

        src = pkgs.fetchFromGitHub {
          owner = "Telegram-FOSS-Team";
          repo = "Telegram-FOSS";
          rev = version;
          fetchSubmodules = true;
          hash = "sha256-R7R7bCSQRieDIKTNzAyth1ft/64gidlzt8L/FkdHtTk=";
        };

        dontConfigure = true;

        buildInputs = with pkgs; [
          androidSdk
          ninja
          go
          cmake
          yasm
          perl
          clang
          apksigner
          gradle_7
          openjdk11
          pkg-config
        ];

        preBuild = ''
          pushd TMessagesProj/jni/

          patchShebangs .

          bash patch_boringssl.sh
          bash build_boringssl.sh # somehow we need to add some go modules for offline use here

          bash build_libvpx_clang.sh
          bash build_ffmpeg_clang.sh
          bash patch_ffmpeg.sh

          popd
        '';

        inherit ANDROID_NDK_ROOT;
        inherit ANDROID_SDK_ROOT;
        NDK = ANDROID_NDK_ROOT;
        NINJA_PATH = "${pkgs.ninja}/bin/ninja";
      };
    };
}
