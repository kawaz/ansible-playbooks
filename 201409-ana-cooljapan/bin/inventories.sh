#!/bin/bash
cd $(dirname "$0") || exit 1
regions=(us-east-1 ap-northeast-1 ap-southeast-1)
cache="${0##*/}.CACHE.json"

if [[ ! -f $cache ]]; then
  hosts=($(
  for region in "${regions[@]}"; do
    AWS_DEFAULT_REGION=$region ./describeOldestInstancesInAutoScalingGroup.sh |
    jq '.Reservations[].Instances[]|.PublicDnsName'
  done
  ))
  json=$(echo "{\"all\":[$(IFS=,; echo "${hosts[*]}")]}" | jq -r .)
  echo "$json" > "$cache"
fi
cat "$cache"
