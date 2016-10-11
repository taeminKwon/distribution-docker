#!/bin/bash -eu

# Install tools
apt-get -y install wget tar

# Setup Imply
wget -q -O- https://static.imply.io/release/imply-$implyversion.tar.gz | tar -xz -C /root
