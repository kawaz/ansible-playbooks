#!/bin/bash
if [[ -f $1 && $1 =~ \.ya?ml$ ]]; then
  playbook=$1
  shift;
fi
[[ -z $1 ]] && { echo "$0 [playbook.yml] hostname [hostname..]"; exit 1; }

inventory="/tmp/inventory-$(sha1sum<<<"$*"|awk '{print $1}')"
for h in "$@"; do
  echo "$h"
done > "$inventory"
ansible-playbook -C -i "$inventory" "${playbook:-base.yml}"
rm -f "$inventory"
