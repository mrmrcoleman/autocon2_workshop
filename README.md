# Installation

## Docker and ContainerLab

```
./1_install_docker_and_clab.sh
```

## Install and start Slurpit

> [!NOTE]
> You need to set the Slurpit version (COMMIT_HASH) and Slurpit portal URL (PORTAL_BASE_URL)

```
COMMIT_HASH="3e2d20458e46cc026d39fde599f01f2a615a2e25" PORTAL_BASE_URL="http://147.28.133.73:8000/" ./2_install_slurpit.sh
```

Now you should be able to log in to Slurpit at `PORTAL_BASE_URL`

```
Username: admin@admin.com
Password: 12345678
```

## Start the ContainerLab network

```
./3_start_network.sh
```

## Start NetBox

> [!NOTE]
> This can take a few minutes. Use `docker compose logs -f`to follow along

```
./4_start_netbox.sh
```
