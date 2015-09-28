#!/bin/bash
set -E
export LANG=C
trap '[ "$?" -ne 100 ] || exit 100' ERR

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

test -z "$1" -o -z "$2" && echo "Usage: bash $0 cloudinit.yml hostname" && exit 1

source $DIR/openstack.rc || (echo Configure openstack.rc first && exit 100)

NET_ADMIN=${NET_ADMIN:-$(neutron net-list | grep adm | awk '{print $2}')}
NET_OVERLAY=${NET_OVERLAY:-$(neutron net-list | grep overlay | awk '{print $2}')}
NET_PUBLIC=${NET_PUBLIC:-$(neutron net-list | grep public | awk '{print $2}')}
PORT_ADMIN=$(neutron port-create $NET_ADMIN | grep " id " | awk '{print $4}')
FLOATING_IP=$(neutron floatingip-create $NET_PUBLIC | grep " id " | awk '{print $4}')

neutron floatingip-associate $FLOATING_IP $PORT_ADMIN
neutron floatingip-show $FLOATING_IP

nova boot --flavor "$FLAVOR" --image "$IMAGE" --nic port-id=$PORT_ADMIN --nic net-id=$NET_OVERLAY --key-name $KEY_NAME --user-data ${1} ${2}
