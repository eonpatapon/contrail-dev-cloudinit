A set of flies/scripts to run a devstack+contrail against a local machine (libvirt) or an openstack cloud.

Local libvirt
=============

The script will use the `.ssh/id_rsa.pub` key in the cloudinit configuration.

The script will create automatically the networks "overlay" (192.168.123.0/24),
"adm" (192.168.124.0/24) and "default (192.168.122.0/24 - nat mode)" if they
don't exists.

Run `./libvirt-install.sh master.yml <VM_NAME>`

SSH the VM with the user cloud.

Openstack
=========

Create a private network "adm" on your tenant. You must have a nova keypair installed.

Copy openstack.rc.example to openstack.rc and adjust the settings.

Source your Openstack credentials before running the script.

Run `./openstack-install.sh master.yml <VM_NAME>`

SSH the VM with the user cloud.

Usage
=====

Once the script is run and the VM booted you can SSH the VM as cloud user and attach a tmux session.
There is one window for the contrail build and another for the devstack build.
