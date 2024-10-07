#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("MY_EXTERNAL_IP" "NETPICKER_PORT" "NETPICKER_API_PORT")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

echo
echo "--- Starting Netpicker ---"
echo

pushd netpicker
docker compose up -d
popd