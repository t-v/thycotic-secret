#!/bin/bash

cd /thycotic

ansible-playbook generate_openshift_secrets.yml --connection=local -vvv