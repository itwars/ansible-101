#!/bin/bash

function box() {
  title="│ $* │"
  edgeTop=$(echo "$title" | sed 's/./─/g')
  edgeBot=$(echo "$title" | sed 's/./─/g')
  echo $edgeTop | sed s/─/┌/1 | sed s/─$/┐/
  echo $title
  echo $edgeBot | sed s/─/└/1 | sed s/─$/┘/
}

box "Remove existing containers"
docker rm -f debian1 ubuntu1 alpine1
box "Remove existing ssh key file"
rm ./id_rsa

box "Create new container : Debian"
docker run --name debian1 --hostname debian1 -d -v /etc/localtime:/etc/localtime:ro debian-ansible
box "Create new container : Ubuntu"
docker run --name ubuntu1 --hostname ubuntu1 -d -v /etc/localtime:/etc/localtime:ro ubuntu-ansible
box "Create new container : Alpine"
docker run --name alpine1 --hostname alpine1 -d -v /etc/localtime:/etc/localtime:ro alpine-ansible

box "Create new RSA ssh key"
ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date)" -f ./id_rsa -q -N ""
box "Copy ssh key on each container -- password is 'toor'" "yellow" "purple"
docker ps --format "{{.Names}}" | grep "debian\|ubuntu\|alpine" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i ssh-copy-id -i ./id_rsa root@{}

box "Create Ansible hosts file"
echo [debian] > hosts
docker ps --format "{{.Names}}" | grep "debian" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts

echo [ubuntu] >> hosts
docker ps --format "{{.Names}}" | grep "ubuntu" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts

echo [alpine] >> hosts
docker ps --format "{{.Names}}" | grep "alpine" | xargs -i docker inspect -f "{{ .NetworkSettings.IPAddress }}" {} | xargs -i echo {} ansible_user=root >> hosts
