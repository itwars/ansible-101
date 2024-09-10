#!/bin/sh

docker build -t alpine-ansible alpine-ansible/.
docker build -t debian-ansible debian-ansible/.
docker build -t ubuntu-ansible ubuntu-ansible/.
docker build -t ansible-cli    ansible-cli/.
