# Installation

## Docker and ContainerLab

```
./1_install_docker_and_clab.sh
```

## Install and start Slurpit

```
./2_install_slurpit.sh
```

Now you can log in to Slurpit at http://autocon-workshop.netboxlabs.tech/

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

## Start nginx

> [!NOTE]
> Makes Slurpit available on /slurpit and NetBox available on /netbox

```
./5_start_nginx.sh
```