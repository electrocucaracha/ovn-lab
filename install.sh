#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2018
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o nounset
set -o pipefail

pkgs="sshpass"
if ! command -v ansible; then
    pkgs+=" ansible"
fi
if [ -n "$pkgs" ]; then
    curl -fsSL http://bit.ly/install_pkg | PKG=$pkgs bash
fi
sudo mkdir -p /etc/ansible/
sudo tee <<EOL /etc/ansible/ansible.cfg
[defaults]
host_key_checking = false
EOL
ansible-playbook -vvv -i ./hosts.ini ./configure-ovn.yml | tee ~/setup-ovn.log
