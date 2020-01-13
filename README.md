# OpenVSwitch & OVN

This project was created to validate the process to install
[Open vSwitch][1] and [Open Virtual Network][2] through ansible
playbooks as method to provision.

This is also helpful to quickly setup a lab described on the post of
["A Primer on OVN"][3]

## Setup

This project uses [Vagrant tool][4] for provisioning Virtual Machines
automatically. It's highly recommended to use the  *setup.sh* script
of the [bootstrap-vagrant project][5] for installing Vagrant
dependencies and plugins required for its project. The script
supports two Virtualization providers (Libvirt and VirtualBox).

    $ curl -fsSL http://bit.ly/initVagrant | PROVIDER=libvirt bash

Once Vagrant is installed, it's possible to deploy the lab with the
following instructions:

    $ vagrant up && vagrant up installer

## License

Apache-2.0

[1]: http://docs.openvswitch.org/en/latest/topics/#ovs
[2]: http://docs.openvswitch.org/en/latest/topics/#ovn
[3]: http://blog.spinhirne.com/2016/09/a-primer-on-ovn.html
[4]: https://www.vagrantup.com/
[5]: https://github.com/electrocucaracha/bootstrap-vagrant
