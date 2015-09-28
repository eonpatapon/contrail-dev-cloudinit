#!/bin/sh
set -E
trap '[ "$?" -ne 100 ] || exit 100' ERR

LANG=C

test -f $HOME/.ssh/id_rsa.pub || (echo "Can't find any SSH key" && exit 100)
SSH_KEY=$(cat $HOME/.ssh/id_rsa.pub)

test -z "$1" && echo "Usage: bash $0 cloudinit.yml hostname iso_path" && exit 1

mkdir -p iso
cp $1 iso/user-data
cat << EOF > iso/meta-data
instance-id: iid-local01
local-hostname: $2
network-interfaces: |
    auto eth0
    iface eth0 inet dhcp
    auto eth1
    iface eth1 inet dhcp
    auto eth2
    iface eth2 inet dhcp
public-keys:
    - $SSH_KEY
EOF
genisoimage -volid cidata -joliet -rock -o $3 iso
rm -rf iso
