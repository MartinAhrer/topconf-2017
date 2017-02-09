#!/usr/bin/env bash
source ./common.sh
terraform output --json | jq -r .id.value[] | while read droplet_id; do doctl --access-token $DIGITALOCEAN_ACCESS_TOKEN compute droplet-action shutdown ${droplet_id}; done
