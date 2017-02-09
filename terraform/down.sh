#!/usr/bin/env bash
set -x

source ./common.sh
terraform destroy -var "digitalocean_access_token=$DIGITALOCEAN_ACCESS_TOKEN"
