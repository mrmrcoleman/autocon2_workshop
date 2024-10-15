# Installation

## Set environment variables

This script sets all the necessary envirionment variables so that the correct ports are used for the services and defaults to using the public IPv4 of the host for service URLs.

```
source ./0_set_envvars.sh
```

Keep the output from this handy somewhere as we'll reference it a lot.

## Install Docker and ContainerLab

```
./1_install_docker_and_clab.sh
```

Check it was successful:

```
docker version
clab version
```

## Start Slurpit

```
./2_start_slurpit.sh
```

Now you can access Slurpit.

```
echo "http://${MY_EXTERNAL_IP}:${SLURPIT_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8000

```

> [!TIP]
> 
> **username** admin@admin.com  
> **password** 12345678  

## Start the ContainerLab network

```
./3_start_network.sh
```

Check it's working:

```
pushd network

clab inspect
INFO[0000] Parsing & checking topology file: autocon2.clab.yml 
+---+----------------------+--------------+-----------------------------------+---------------+---------+---------------+--------------+
| # |         Name         | Container ID |               Image               |     Kind      |  State  | IPv4 Address  | IPv6 Address |
+---+----------------------+--------------+-----------------------------------+---------------+---------+---------------+--------------+
| 1 | clab-autocon2-client | 735ca05560ba | mrmrcoleman/autocon-client:latest | linux         | running | 172.24.0.8/24 | N/A          |
| 2 | clab-autocon2-server | 13fea0572cbb | mrmrcoleman/autocon-server:latest | linux         | running | 172.24.0.7/24 | N/A          |
| 3 | clab-autocon2-srl1   | 4597ee74f8e8 | ghcr.io/nokia/srlinux:24.7.2      | nokia_srlinux | running | 172.24.0.9/24 | N/A          |
| 4 | clab-autocon2-srl2   | f6e672e36f59 | ghcr.io/nokia/srlinux:24.7.2      | nokia_srlinux | running | 172.24.0.6/24 | N/A          |
+---+----------------------+--------------+-----------------------------------+---------------+---------+---------------+--------------+

popd
```

## Start NetBox with the Slurpit plugin

> [!TIP]
> This can take 2-3 minutes. Use `docker compose logs -f` in a separate tab to follow along.  
> If you see `Error` next to the `netbox-docker-netbox-1` container this is often because the healthcheck timeout is shorter than the start up time and it will recover itself automatically.

```
./4_start_netbox.sh
```

Now you can access NetBox.

```
echo "http://${MY_EXTERNAL_IP}:${NETBOX_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8001
```

> [!TIP]
>  
> **username** admin  
> **password** admin

## Start Icinga

```
./5_start_icinga.sh
```

Now you can access Icinga.

```
echo "http://${MY_EXTERNAL_IP}:${ICINGA_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8002
```

> [!TIP]
>   
> **username** icingaadmin  
> **password** icinga

## Start Netpicker

```
./6_start_netpicker.sh
```

Now you can access Netpicker.

```
echo "http://${MY_EXTERNAL_IP}:${NETPICKER_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8003
```

> [!TIP]
> 
> **username** admin@admin.com  
> **password** 12345678
