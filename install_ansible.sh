#!/bin/sh

sh_c='sh -c'
if [ "$(id --name --user)" != 'root' ]
  then
  if command -v sudo
    then
    sh_c='sudo -E sh -c'
  elif command -v su
    then
    sh_c='su --command'
  else
    exit 1
  fi
fi

version="==$1"
command -v yum &&
  $sh_c 'sleep 3
    yum --assumeyes install epel-release &&
    yum --assumeyes install PyYAML \
                            python-paramiko \
                            python-jinja2 \
                            python-setuptools \
                            python-httplib2 \
                            python-keyczar \
                            python-pip \
                            sshpass \
                            git'

command -v apt-get &&
  $sh_c 'sleep 3
    apt-get update &&
    apt-get --assume-yes install python-yaml \
                                 python-paramiko \
                                 python-jinja2 \
                                 python-setuptools \
                                 python-httplib2 \
                                 python-keyczar \
                                 python-pip \
                                 sshpass \
                                 git'

$sh_c "pip install ansible${1:+$version}"