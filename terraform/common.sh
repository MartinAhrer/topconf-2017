#!/usr/bin/env bash
export DIGITALOCEAN_ACCESS_TOKEN=$(grep "access-token" $HOME/.config/doctl/config.yaml  | awk {'print $2'})
