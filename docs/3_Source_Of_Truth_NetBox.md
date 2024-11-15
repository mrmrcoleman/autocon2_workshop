### NetBox - Our Network Source of Truth

A Network Source of Truth like [NetBox](https://netboxlabs.com/) is the bedrock of any network automation stategy. NetBox acts as your living documentation and captures the Low Level Design of your network, but initially our NetBox is empty (apart from a site called Slurpit, which you can ignore for now.)

Populating NetBox typically happens in two stages:

1. Set up the organizational specifics like tenants, sites, and more
2. Import our devices from the network

So we can focus on intent-based networking, the NetBox instance is already pre-configured with our organizational specifics. Let's take a look.

```
echo ${MY_EXTERNAL_IP}:${NETBOX_PORT}
(Example output, yours will differ)
147.75.34.179:8001
```

> [!TIP]
> 
> **username** admin
> **password** admin

- Sites
- Contacts
- Custom Fields

> [!TIP]
> 
> If you're interested in learning more about NetBox check out the [NetBox Zero to Hero course](https://netboxlabs.com/zero-to-hero/)  
> It's packed with useful information and instructional videos to give you a deeper understanding of NetBox's capabilities

With our organizational specifics in NetBox, now we need to import our devices from the network.