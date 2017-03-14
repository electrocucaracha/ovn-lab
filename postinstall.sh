#!/bin/bash

apt-get update
apt-get install -y git

cat <<EOL > /etc/gitconfig
[url "https://"]
        insteadof = git://
EOL

git clone https://github.com/mininet/mininet.git
./mininet/util/install.sh -a

# sudo mn --test pingall
