#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("MY_EXTERNAL_IP" "ICINGA_PORT" "SLURPIT_PORT" "NETBOX_PORT" "NETPICKER_PORT")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

echo
echo "--- Cloning Icinga2 ---"
echo

git clone -b master https://github.com/davekempe/icinga2-docker-stack/
pushd icinga2-docker-stack

echo
echo "--- Writing configuration ---"
echo

echo "MYSQL_ROOT_PASSWORD=12345678" > secrets_sql.env
echo "NETBOX_URL=http://${MY_EXTERNAL_IP}:${ICINGA_PORT}/api" >> secrets_sql.env
echo "NETBOX_APIKEY=1234567890" >> secrets_sql.env

# Remove SSL/TLS
sed -i '/4443:443/d' docker-compose.yml

# Update the outside port
sed -i 's/8080:80/${ICINGA_PORT}:80/' docker-compose.yml

# Uncomment the credentials
sed -i 's/^ *#- ICINGAWEB2_ADMIN_USER=icingaadmin/      - ICINGAWEB2_ADMIN_USER=icingaadmin/' docker-compose.yml
sed -i 's/^ *#- ICINGAWEB2_ADMIN_PASS=icinga/      - ICINGAWEB2_ADMIN_PASS=icinga/' docker-compose.yml

echo
echo "--- Starting Icinga2 ---"
echo

docker compose up -d

popd
echo "Icinga should be at http://${MY_EXTERNAL_IP}:${ICINGA_PORT}"
echo "username: icingaadmin"
echo "password: icinga"

echo "(wait a minute or so for it to finish starting all the bits)"
