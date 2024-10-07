#!/bin/bash
set -euo pipefail

# pushd to Slurpit directory
pushd slurpit

# Check if all required environment variables are set
REQUIRED_VARS=("MY_EXTERNAL_IP" "SLURPIT_PORT")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

echo
echo "--- Starting Slurpit ---"
echo
docker compose up -d

# Return to the original directory
popd