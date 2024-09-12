#!/usr/bin/env bash

docker build --tag telegram-foss .
docker run --rm -v $PWD:/home/source -it telegram-foss
cp TMessagesProj/build/outputs/apk/afat/release/app.apk telegram.apk
apksigner sign --ks debug.keystore --ks-key-alias android telegram.apk
