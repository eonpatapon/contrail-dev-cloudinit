#!/bin/bash
export LANG=C
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

test -z "$1" && echo "Usage: bash $0 hostname" && exit 1

ISO_PATH=$DIR/vms/${1}-config.iso
DISK_PATH=$DIR/vms/${1}.img

virsh -c qemu:///system dumpxml $1 &>/dev/null && virsh -c qemu:///system destroy $1 && virsh -c qemu:///system undefine $1
test -f $ISO_PATH && rm -f $ISO_PATH
test -f $DISK_PATH && rm -f $DISK_PATH

echo $1 deleted.
