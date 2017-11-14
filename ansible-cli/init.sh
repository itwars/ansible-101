#!/bin/bash

source ./box.sh

box "Remove existing containers" "blue" "red"
docker rm -f debian1 ubuntu1 centos1
box "Remove existing ssh key file" "blue" "red"
rm ./id_rsa
box "Create new container : Debian" "green" "blue"
docker run --name debian1 --hostname debian1 -d -v /etc/localtime:/etc/localtime:ro itwars/debian-ansible
box "Create new container : Ubuntu" "green" "blue"
docker run --name ubuntu1 --hostname ubuntu1 -d -v /etc/localtime:/etc/localtime:ro itwars/ubuntu-ansible
box "Create new container : Centos" "green" "blue"
docker run --name centos1 --hostname centos1 -d -v /etc/localtime:/etc/localtime:ro itwars/centos-ansible
box "Create new RSA ssh key" "green" "blue"
ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date)" -f ./id_rsa -q -N ""
box "Copy ssh key on each container -- password is 'toor'" "yellow" "purple"
docker ps --format "{{.Names}}" | grep "debian\|ubuntu\|centos" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i ssh-copy-id -i ./id_rsa root@{}
box "Create Ansible hosts file" "green" "blue"
echo [debian] > hosts
docker ps --format "{{.Names}}" | grep "debian" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
echo [ubuntu] >> hosts
docker ps --format "{{.Names}}" | grep "ubuntu" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
echo [centos] >> hosts
docker ps --format "{{.Names}}" | grep "centos" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
