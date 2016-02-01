#!/bin/bash
export LANG=C
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

test -z "$1" -o -z "$2" && echo "Usage: bash $0 cloudinit.yml hostname" && exit 1

test -d $DIR/images || mkdir $DIR/images
test -d $DIR/vms || mkdir $DIR/vms

ISO_PATH=$DIR/vms/${2}-config.iso
DISK_PATH=$DIR/vms/${2}.img

virsh -c qemu:///system dumpxml $2 &>/dev/null && echo "The VM ${2} disk already exists. Aborting." && exit 1
test -f $ISO_PATH && echo "An iso disk already exists at $ISO_PATH. Aborting." && exit 1
test -f $DISK_PATH && echo "A VM disk already exists at $DISK_PATH. Aborting." && exit 1

$DIR/build-nocloud-metadata.sh ${1} ${2} $ISO_PATH

test -f $DIR/images/trusty-server-cloudimg-amd64-disk1.img || wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img -O $DIR/images/trusty-server-cloudimg-amd64-disk1.img

cp $DIR/images/trusty-server-cloudimg-amd64-disk1.img $DISK_PATH
qemu-img resize $DISK_PATH +30GB

virsh -c  qemu:///system net-info default || virsh -c  qemu:///system net-create conf/libvirt-net-default.xml
virsh -c  qemu:///system net-info overlay || virsh -c  qemu:///system net-create conf/libvirt-net-overlay.xml
virsh -c  qemu:///system net-info adm || virsh -c  qemu:///system net-create conf/libvirt-net-adm.xml

virt-install --connect qemu:///system --import -n $2 -r 4096 -w network=adm,model=virtio -w network=overlay,model=virtio -w network=default --disk path=$DISK_PATH --disk path=$ISO_PATH,device=cdrom --noautoconsole

MAC_ADM=$(virsh -c qemu:///system dumpxml $2 | grep 'mac address' | head -n1 | cut -d"'" -f2)

echo Waiting to get the VM IP address...
while true
do
    IP_ADM=$(arp -en | grep $MAC_ADM | awk '{ print $1 }')
    test ! -z $IP_ADM && break
    sleep 1
done

echo VM admin IP is $IP_ADM
echo ssh cloud@$IP_ADM
