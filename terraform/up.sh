#!/usr/bin/env bash
set -x

# export TF_VAR_machines=n to bring up n machines
export MACHINE_STORAGE_PATH=$PWD/docker-machine
mkdir -p ${MACHINE_STORAGE_PATH}

source ./common.sh

terraform plan -var "digitalocean_access_token=$DIGITALOCEAN_ACCESS_TOKEN"
terraform apply -var "digitalocean_access_token=$DIGITALOCEAN_ACCESS_TOKEN"
