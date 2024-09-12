#!/bin/sh

docker run -it --rm --workdir /root -v `pwd`:/root ansible-cli ansible-galaxy $@
