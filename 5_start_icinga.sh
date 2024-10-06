#!/bin/bash
set -euo pipefail

echo
echo "--- Cloning Icinga ---"
echo

git clone -b master https://github.com/jjethwa/icinga2.git
pushd icinga2

echo
echo "--- Writing configuration ---"
echo

echo "MYSQL_ROOT_PASSWORD=12345678" > secrets_sql.env

# Remove SSL/TLS
sed -i '/443:443/d' docker-compose.yml

# Update the outside port
sed -i 's/80:80/8002:80/' docker-compose.yml

# Uncomment the credentials
sed -i 's/^ *#- ICINGAWEB2_ADMIN_USER=icingaadmin/      - ICINGAWEB2_ADMIN_USER=icingaadmin/' docker-compose.yml
sed -i 's/^ *#- ICINGAWEB2_ADMIN_PASS=icinga/      - ICINGAWEB2_ADMIN_PASS=icinga/' docker-compose.yml


echo
echo "--- Starting Icinga ---"
echo

docker compose up -d

popd