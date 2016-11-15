#!/bin/bash

#git pull && git submodule update --init && make -j$(nproc)
docker build -t jormungandr -f  Dockerfile-jormungandr .
docker build -t kraken -f Dockerfile-kraken .
docker build -t tyr -f Dockerfile-tyr .


