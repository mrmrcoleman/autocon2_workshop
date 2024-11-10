#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("WORKSHOP_SUBNET")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

sudo apt install needrestart -y

echo "--- Setting noninteractive and updating repos ---"
export DEBIAN_FRONTEND=noninteractive
echo "\$nrconf{restart} = 'l';" | sudo tee /etc/needrestart/conf.d/90-autorestart.conf > /dev/null
sudo apt-get update

# Install venv
sudo apt install -y python3-venv

# Install net-tools
sudo apt install -y net-tools

# Install snmpwalk
sudo apt install -y snmp

# Install Docker
echo "--- Installing Docker ---"

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo install -o root -g root /dev/stdin /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Install ContainerLab
echo "--- Installing ContainerLab ---"

curl -sL https://containerlab.dev/setup | sudo -E bash -s "install-containerlab"

# Check the OS type and version
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot determine OS type."
    exit 1
fi

if [ "$ID" == "ubuntu" ]; then
    # Ubuntu installation steps
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    echo "Ansible installed on Ubuntu."

elif [ "$ID" == "debian" ] && [ "$VERSION_ID" == "12" ]; then
    # Debian 12 installation steps
    UBUNTU_CODENAME=jammy
    wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
    sudo apt update
    sudo apt install -y ansible
    echo "Ansible installed on Debian 12."
else
    echo "Unsupported OS or version."
    exit 1
fi

# set netbox url in the inventory file
#
sed -i "s/%%URL%%/$MY_EXTERNAL_IP:$NETBOX_PORT/" ansible/inventory/netbox.yml


# Start docker
sudo systemctl start docker

# Get the current username using whoami
current_user=$(whoami)

# Check if the current user is in the docker group
if groups $current_user | grep -q "\bdocker\b"; then
    echo "User $current_user is in the docker group."
else
    echo "User $current_user is NOT in the docker group."
	sudo adduser $current_user docker
fi

echo
echo "--- Creating Docker Network ---"
echo

docker network create --driver=bridge --subnet=${WORKSHOP_SUBNET} autocon-workshop
