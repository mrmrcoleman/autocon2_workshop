# NetBox Automation - Zero to Hero

Welcome to NetBox Automation - Zero to Hero! In this workshop we will build a fully functioning intent-based network automation stack. While most vendors do a great job of showing you how to use their tool, network automation is a multi-tool adventure and there is lack of tutorials and documentation showing how everything fits together.

This workshop is intended to teach you the high-level concepts around intent-based networking, while also delivering you a fully functioning stack you can continue to experiment with. The workshop is split into sections covering different elements of the story. You should follow them sequentially.


## Sections

1. [Managing Networks the Hard Way](docs/1_Managing_Networks_The_Hard_Way.md) - A look at a "traditional" network management stack, and we'll discuss some of the issues with it.
2. [Introducing Intent-Based Network Automation](docs/2_Introducing_Intent_Based_Network_Automation.md) - A brief introduction to the high-level concepts that we'll be building through the rest of the workshop.
3. [Source of Truth: NetBox](docs/3_Source_Of_Truth_NetBox.md) - An introduction to NetBox, our Network Source of Truth that will drive our intent-based networking
4. [Discovery and Reconcilliation: Slurpit](docs/4_Discovery_Reconciliation_Slurpit.md)
5. [Monitoring: Icinga](docs/5_Monitoring_Icinga.md)
6. [Configuration Assurance: Netpicker](docs/6_Configuration_Assurance_Netpicker.md)
7. [Automated Network Changes: Ansible](docs/7_Automated_Network_Changes_Ansible.md)

# Workshop

## Moving towards Intent Based Networking

Much has been written about network automation and Intent Based Networking, so rather than adding to that, we're going to learn by doing. In the next sections we will introduce various modern tools and techniques make sure that changing our networks is less painful.

### NetBox - Our Network Source of Truth

A Network Source of Truth like [NetBox](https://netboxlabs.com/) is the bedrock of any network automation stategy. NetBox acts as your living documentation and captures the Low Level Design of your network, but initially our NetBox is empty (apart from a site called Slurpit, which you can ignore for now.)

Populating NetBox typically happens in two stages:

1. Set up the organizational specifics like tenants, sites, and more
2. Import our devices from the network

#### Set up the organizational specifics like tenants, sites, and more

For our network this step will be very simple as our devices will live in a single site called "Denver". Let's go and add that now. First we need to get the IP and port for NetBox.

```
echo ${MY_EXTERNAL_IP}:${NETBOX_PORT}
(Example output, yours will differ)
147.75.34.179:8001
```

> [!TIP]
> 
> **username** admin
> **password** admin

Now you can log-in and add the site under Organization -> Sites:

<img src="images/netbox/create_site.png" alt="Create NetBox Site" title="Create NetBox Site" width="750" />



### Netpicker - Our configuration assurance tool

Netpicker allows us to validate our device configurations. It can be used to validate anything you can express in code, but also makes it easy to generate validations even if you can't code. Perhaps you'd like to know if there are any known vulnerabilities for a platform version you're running in your network, or if your device configurations adhere to your company's security policies? Netpicker can do all of that and more.

To get started we need to tell NetPicker about our devices. Now that we have NetBox as our Network Source of Truth, we'll be importing our devices from NetBox into Netpicker.

First log-in to Netpicker and click on `Add Device`

```
echo "http://${MY_EXTERNAL_IP}:${NETPICKER_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8003
```

> [!TIP]
> 
> **username** admin@admin.com  
> **password** 12345678

<img src="images/netpicker/homepage_add_device.png" alt="NetPicker Homepage Add Devices" title="NetPicker Homepage Add Devices" width="1000" />

Now click on `+ Add devices` and then click on `Import from NetBox`

<img src="images/netpicker/add_devices_menu.png" alt="NetPicker Add Devices" title="NetPicker Add Devices Menu" width="300" />

Then provide your NetBox URL, NetBox API key (1234567890) and click `Next`

```
echo "http://${MY_EXTERNAL_IP}:${NETBOX_PORT}"
(Example output, yours will differ)
http://139.178.74.171:8001
```

<img src="images/netpicker/netbox_api_details.png" alt="NetBox API Details" title="NetBox API Details" width="1000" />

Then on the next screen choose `IP address / FQDN field (required)` choose `name (-)`and under `Vault` select `autocon_workshop`. Then click `Next`

<img src="images/netpicker/device_mapping.png" alt="Netpicker Device Mapping" title="Netpicker Device Mapping" width="1000" />

Our network devices have now been imported from NetBox into Netpicker!

___

Next we need to ask Netpicker to pull the configuration backups for our devices so that we can run tests, which Netpicker calls `Policies`, against them.

On the `Devices` screen click `Run backups`

INSERT RUN BACKUPS SCREENSHOT

Navigate over to `Backups` and wait for the backups to arrive. You can hit `Refresh` to update the view until both backups report `Success`.

INSERT BACKUPS SCREENSHOT

You can now inspect the backups. Click on `clab-autocon2-srl1`. Then you can click on each backup to view it.

INSERT BACKUP DETAILS VIEW

Now that Netpicker is pulling the backups from our devices, we can use the real power of Netpicker, `Policies` and `Rules`.

