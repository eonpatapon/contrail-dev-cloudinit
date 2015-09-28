A set of flies/scripts to run a devstack+contrail against a local machine (libvirt) or an openstack cloud.

Local libvirt
=============

Create two private networks "overlay" and "adm".
The script will use the `.ssh/id_rsa.pub` key in the cloudinit configuration.

Run `./libvirt-install.sh devstack-contrail-juno.yml <VM_NAME>`

SSH the VM with the user cloud.

Openstack
=========

Create two private networks "overlay" and "adm" on your tenant. You must have a nova keypair installed.

Copy openstack.rc.example to openstack.rc and adjust the settings.

Source your Openstack credentials before running the script.

Run `./openstack-install.sh devstack-contrail-juno.yml <VM_NAME>`

SSH the VM with the user cloud.

Usage
=====

Once the script is run and the VM booted you can SSH the VM as cloud user and attach a tmux session.
There is one window for the contrail build and another for the devstack build.
