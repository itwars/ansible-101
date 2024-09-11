#!/bin/sh

docker run -it --rm -v `pwd`/hosts:/etc/ansible/hosts -v `pwd`/id_rsa:/root/.ssh/id_rsa ansible-cli ansible $@
