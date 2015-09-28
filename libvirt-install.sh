#!/bin/bash
export LANG=C
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

test -z "$1" -o -z "$2" && echo "Usage: bash $0 cloudinit.yml hostname" && exit 1

test -d $DIR/images || mkdir $DIR/images
test -d $DIR/vms || mkdir $DIR/vms

ISO_PATH=$DIR/vms/${2}-config.iso
DISK_PATH=$DIR/vms/${2}.img

$DIR/build-nocloud-metadata.sh ${1} ${2} $ISO_PATH

test -f $DIR/images/trusty-server-cloudimg-amd64-disk1.img || wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img -O $DIR/images/trusty-server-cloudimg-amd64-disk1.img

cp $DIR/images/trusty-server-cloudimg-amd64-disk1.img $DISK_PATH
qemu-img resize $DISK_PATH +30GB

virt-install --connect qemu:///system --import -n $2 -r 4096 -w network=default -w network=overlay,model=virtio -w network=adm,model=virtio --disk path=$DISK_PATH --disk path=$ISO_PATH,device=cdrom --noautoconsole
