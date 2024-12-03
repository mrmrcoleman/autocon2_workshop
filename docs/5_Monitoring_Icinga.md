# Verifying Intent - Monitoring driven from your SoT

To make sure your network is in the right state for this section, you can use the following command: `./3_start_network.sh network/5.1_monitoring`

Monitoring can be defined as the process to check to see if the stuff we care about is working. 
When the monitoring tool can be configured from your Source of Truth, our intent can be verified.

<img src="images/icinga/netbox-icinga.png" alt="Netbox and Icinga logos" title="Netbox and Icinga" width="1000" />

[Icinga](https://icinga.com/) is a full featured, fully open source monitoring system. 

The [integration](https://github.com/sol1/icingaweb2-module-netbox) between Icinga and NetBox lets us configure monitoring from our SoT which creates a feedback loop. The  monitoring lets us know that the data in Netbox is valid.

As the integration is very mature, it can handle many data types and edge cases. In addition all manner of grouping can be provided, so for example, SNMP settings per device type or latency per site, or NTP servers per region can all be imported and configuration created in Icinga. 

Lets get started!

___

The first step is to update the device states in Netbox so that they will be imported by Icinga. Slurpit creates devices with a default status of `Inventory`. To be monitored by Icinga, their status needs to be set to `Active`.

First login to NetBox.

> [!TIP]
> **NetBox URL**: `./0_set_envvars.sh | grep -i netbox`  
> **username** admin  
> **password** admin

Navigate to `Devices -> Devices`, select both Devices and then click `Edit Selected`. Set Status to `Active`, and `the `Icinga import source` to `Default`. The click `Apply`.

> [!TIP]
> The `Icinga import source` field allows us to define diffrent "profiles" in the Icinga Director Import Sources.  

Now login to Icinga.

> [!TIP]
> **Icinga URL**: `./0_set_envvars.sh | grep -i icinga`  
> **username** icingaadmin  
> **password** icinga

Our devices are now being imported into Icinga. Once they are imported the predefined monitoring, known as `Checks`, will begin. Keep an eye on `Overview` -> `Tactical Overview`. (It can take a minute or so to see them appear.)

- INSERT SCREENSHOT OF TACTICAL OVERVIEW and explain that one of them is the Icinga host itself.

- Click on the number 3 under hosts to be taken to http://147.182.198.119:8002/icingaweb2/icingadb/hosts?host.state.soft_state=0

- INSERT SCREENSHOT OF MONITORED HOSTS

- Back on the tactical overview page, click on the GREEN 9 under services

- INSERT SCREENSHOT OF GREEN 9

- INSERT SCREENSHOT OF MONITORED SERVICES and explain what they are: http://147.182.198.119:8002/icingaweb2/icingadb/services?service.state.soft_state=0

### Workshop Specific Plugin

For this workshop, we have a special check that pings the OTHER Nokia device from each device. This is controlled by the custom field ping_target, and if you set this to the valid target, the ping will come from the nokia device itself. 

Once the device automatically imports into Icinga, you can see the checks being applied automatcaily. This incldues ping (of the primary IP), SSH, an SNMP uptime command. These Icinga Services are applied automatically when a device with the Netbox manufacturer Nokia is created as an Icinga Host. The concept of Icinga Apply Rules is very powerful, and means we can use any Netbox Data to create a dynamic and accurate set of Services.

### Bonus Other Checks

We have also included other checks in the Icinga configuration, which can check SSL certifcates, as an example. 
To try this out
1. Add a device, or virtual machine to Netbox, and set it to Active, import_source default, and it should get a ping check.
2. Add to the same Netbox device/virtual machine a service using the service template `SSL -` and set the service's Icinga list custom field a fqdn or comma seperated fqdn's, the Icinga automation will add to the hosts service that check the SSL certificate for those fqdn(s). For example, you could add a device called google, give it a valid Google IP, and setup a service for SSL with the ssl_hostname set to www.google.com, Icinga will automatically create the host and setup a service that checks the certifcate for you. 

There is much more power available to this integration, and once you realise that Netbox can drive the config of your monitoring completely, it becomes easy and sustainable.

### Notifications

As another bonus option, the Netbox Contacts can be imported, and assigned to devices or virtual machines. Using a Contact Assignment, of type 'engineer' we can effectively subscribe to alerts from this device. This gives us a powerful way of documenting the relationships between man and machine, and making sure the right person gets the right alerts.
Go ahead and add yourself as a contact, and add your email. Assign a device to yourself and try it out.


