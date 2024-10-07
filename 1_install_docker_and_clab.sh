# NOTE: This script has only been tested on Ubuntu 22.04 LTS
#!/bin/bash
set -euo pipefail

echo "--- Setting noninteractive and updating repos ---"
export DEBIAN_FRONTEND=noninteractive
echo "\$nrconf{restart} = 'l';" > /etc/needrestart/conf.d/90-autorestart.conf
apt-get update

# Install unzip
echo
echo "--- Installing unzip ---"
echo
apt install -y unzip

# Install Docker and Compose
echo "--- Installing Docker and ContainerLab ---"
curl -sL https://containerlab.dev/setup | sudo bash -s "all"

# Start docker
systemctl start docker