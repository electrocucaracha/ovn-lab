#!/bin/bash

apt-get update
apt-get install -y build-essential fakeroot debhelper dh-autoreconf libssl-dev

wget http://openvswitch.org/releases/openvswitch-2.5.0.tar.gz
tar xf openvswitch-2.5.0.tar.gz
pushd openvswitch-2.5.0/

DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary

popd
dpkg -i openvswitch-switch_2.5.0-1_amd64.deb openvswitch-common_2.5.0-1_amd64.deb
