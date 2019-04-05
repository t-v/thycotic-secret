#!/bin/bash

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

cd /thycotic

# scl enable python27 bash
# source scl_source enable python27
# export LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64

ansible-playbook generate_openshift_secrets.yml --connection=local -vvvvv || true
sleep 1000