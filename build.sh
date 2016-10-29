#!/bin/bash

#git pull && git submodule update --init && make -j$(nproc)
#pushd source && docker build -t jormungandr -f  Dockerfile-jormungandr . && popd
pushd kraken && docker build -t kraken -f Dockerfile-kraken . && popd
docker build -t kraken -f Dockerfile-tyr .


