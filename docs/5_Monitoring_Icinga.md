# Section 6 - Monitoring - Icinga

- Network - 5.1_monitoring

## DK notes

The integration between Icinga and NetBox lets us configure monitoring from our SoT which creates a feedback loop where montioring lets us know that the data in Netbox is valid.
A user can add a device to Netbox, have it be monitored automatically, and effectively check the Netbox data matches real life now and in the future. 

As the integration is very mature, it can handle many data types and edge cases. In addition all manner of grouping can be provided, so for example, SNMP settings per device type or latency per site, or NTP servers per region can all be imported and configuration created in Icinga. This allows for massive scale, sustainable monitoring, with a garunteed lower signal to noise ratio, and happier engineers. 


To demonstrate and progress the lab, the first step is to set the devices in Netbox to be imported by Icinga.
Slurpit creates devices as status=Inventory by default, and Icinga needs them Active. 

Go ahead and set the devices active in Netbox.

In addition, the devices need the custom field  Icinga Import Source set to Default. This is a flexible way of allowing for different entires profiles of integration between Netbox and Icinga, and for example, you could have different teams or even vendors have very different monitoring scopes.

Go ahead and update the Custom Field Icinga Import Source to Default for the workshop Devices.

For this workshop, we have a special check that pings the OTHER Nokia device from each device. This is controlled by the custom field ping_target, and if you se this to the valid taget, the ping will come from the nokia device itlsef. 

Once the device automatically imports into Icinga, you can see the checks being applied automatcaily. This incldues ping (of the primary IP), SSH, an SNMP uptime command. These Icinga Services are applied automatically when a device with the Netbox manufacturer Nokia is created as an Icinga Host. The concept of Icinga Apply Rules is very powerful, and means we can use any Netbox Data to create a dynamic and accurate set of Services.

We have also included other checks in the Icinga configuration, which can check SSL certifcates, as an example. 
To try this out
1. Add a device, or virtual machine to Netbox, and set it to Active, import_source default, and it should get a ping check.
2. Add to the same Netbox device/virtual machine a service using the service template `SSL` and set the service's Icinga list custom field a fqdn or comma seperated fqdn's, the Icinga automation will add to the hosts service that check the SSL certificate for those fqdn(s). For example, you could add a device called google, give it a valid Google IP, and setup a service for SSL with the ssl_hostname set to www.google.com, Icinga will automatically create the host and setup a service that checks the certifcate for you. 

There is much more power available to this integration, and once you realise that Netbox can drive the config of your monitoring completely, it becomes easy and sustainable.
As another bonus option, the Netbox Contacts can be imported, and assigned to devices or virtual machines. Using a Contact Assignment, of type 'engineer' we can effectivel subscribe to alerts from this device. This gives us a powerful way of documenting the relationships between man and machine, and making sure the right person gets the right alerts.
Go ahead and add yourself as a contact, and add your email. Assign a dveice to yourself and try it out.


## dk notes








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
___

Next Section - [**Netpicker - Our configuration assurance tool**](./6_Configuration_Assurance_Netpicker.md)