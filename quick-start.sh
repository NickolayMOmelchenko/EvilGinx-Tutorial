#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install Git and Go
sudo apt install git golang-go -y

# Clone Evilginx2 repository
git clone https://github.com/kgretzky/evilginx2
cd evilginx2

# Build Evilginx2
go build

# Clone phishlets repository
cd phishlets
git clone https://github.com/ArchonLabs/evilginx2-phishlets.git

# Move phishlets into the appropriate directory
cd evilginx2-phishlets/phishlets
mv ./* ../../

# Return to the main evilginx2 directory and run evilginx2
cd ../../../
./evilginx2
