#!/usr/bin/env nix-shell
#!nix-shell -i bash -p apksigner

set -e

docker build --tag mercurygram .
docker run --rm -v $PWD:/home/source -v mercurygram-build-cache:/home/gradle -it mercurygram
cp TMessagesProj/build/outputs/apk/afat/release/app.apk telegram.apk
apksigner sign --ks debug.keystore --ks-key-alias android telegram.apk
