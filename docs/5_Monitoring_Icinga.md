**Section 5 - Monitoring - Icinga**

- Network - 5.1_monitoring

- Introduce Icinga and explain the benefits of using NetBox to drive the monitoring, instead of updating it manually
- Make devices active as this is when Icinga will “see” the devices
- Introduce the checks: https://github.com/mrmrcoleman/autocon2_workshop/issues/50
    - Then they will start getting pinged on the mgmt interfaces
    - Then the ping check between ethernet-1/1 interfaces will start
    - Enrich the checks with an SSH check and an snmp check
- Update the ethernet-1/1 IP to something random in NetBox, Icinga will pick this up and it will break

### Icinga - Our monitoring tool

At this point NetBox will already contain the discovered network. Reset the network to a known good state for this section.

```
./3_start_network.sh network/5.1_icinga_intial_lab

+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
| # |        Name        | Container ID |            Image             |     Kind      |  State  | IPv4 Address  | IPv6 Address |
+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
| 1 | clab-autocon2-srl1 | 29c6d4726320 | ghcr.io/nokia/srlinux:24.7.2 | nokia_srlinux | running | 172.24.0.6/24 | N/A          |
| 2 | clab-autocon2-srl2 | e28b555a039f | ghcr.io/nokia/srlinux:24.7.2 | nokia_srlinux | running | 172.24.0.7/24 | N/A          |
+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
```

The ping from `clab-autocon2-srl1` to `clab-autocon2-srl2` will work.

> [!TIP]
> 
> **username** admin  
> **password** NokiaSrl1!

```
ssh admin@clab-autocon2-srl1

ping -c 4 192.168.0.1 network-instance default
Using network instance default
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=53.4 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=3.87 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=3.93 ms
```

Update the network so that the interface is disabled `clab-autocon2-srl1`

```
./3_start_network.sh network/5.2_icinga_broken_link/

+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
| # |        Name        | Container ID |            Image             |     Kind      |  State  | IPv4 Address  | IPv6 Address |
+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
| 1 | clab-autocon2-srl1 | 29c6d4726320 | ghcr.io/nokia/srlinux:24.7.2 | nokia_srlinux | running | 172.24.0.6/24 | N/A          |
| 2 | clab-autocon2-srl2 | e28b555a039f | ghcr.io/nokia/srlinux:24.7.2 | nokia_srlinux | running | 172.24.0.7/24 | N/A          |
+---+--------------------+--------------+------------------------------+---------------+---------+---------------+--------------+
```

Now the ping from `clab-autocon2-srl1` to `clab-autocon2-srl2` will fail.

> [!TIP]
> 
> **username** admin  
> **password** NokiaSrl1!

```
ssh admin@clab-autocon2-srl1

ping -c 4 192.168.0.1 network-instance default
Using network instance default
ping: connect: Network is unreachable
```