1. nix-shell
1. cd TMessagesProj/jni/
1. bash build_libvpx_clang.sh
1. bash patch_boringssl.sh
1. bash build_boringssl.sh
1. bash build_ffmpeg_clang.sh
1. bash patch_ffmpeg.sh
1. exit
1. docker build --tag telegram-foss .
1. docker run --rm -v $PWD:/home/source -it telegram-foss
1. cp TMessagesProj/build/outputs/apk/afat/release/app.apk telegram.apk
1. keytool -genkey -v -keystore debug.keystore -alias android -keyalg RSA -keysize 2048 -validity 20000
1. keytool -list -keystore debug.keystore
1. jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore    telegram.apk android
1. apksigner sign --ks debug.keystore --ks-key-alias android telegram.apk
1. adb install telegram.apk
