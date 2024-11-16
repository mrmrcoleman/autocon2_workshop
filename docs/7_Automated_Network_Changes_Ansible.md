**Section 7 - Automated Network Changes - Ansible**

- So far we’ve been concentrating on making sure we know what’s going on the network (show the reference architecture)
    - Slurpit tells us if the network still matches our intent in NetBox
    - Icinga tells us if the network is still behaving as we intent in NetBox
    - Netpicker uses NetBox to know which devices to run assurance tests against
    - Imagine having to maintain all of these systems without a shared intent to base them off! Well you probably don’t need to imagine it…
- We spend a lot of time making sure that our observability and assurance is in place, because when we first start with automation we’re often not really in control of our networks
    - We don’t know exactly what is out there, and we don’t have a good sense of how it is changing
    - Once we have that baseline, we can start changing how we interact with the network with peace of mind
- So far you’ve either been manually updating the network, or to save time, you’ve been redeploying the network each time. As this is AutoCon, we should probably start doing some automated updates to the network!

- Options - test for these sanity when you wake up
    - NTP settings per site
        - Show that the NTP is different across devices within the same site. Implication is that NTP is site specific
    - syslog per site configs pushed to a UDP endpoint on the host
    - Password change with a prompt in Ansible



* Make sure the proctors can run the Ansible stuff
    * Access
    * Documentation
* Create VMs and have participants SSH in



* Add custom field in NetBox startup
* Check in all the stuff
* Get Ansible working in virtual environment


* BEFORE WHEN WE FIXED THE NTP SERVERS WE FOUND OURSELVES DOING A LOT OF REPEATED STEPS ACROSS DEVICES.... NOW IMAGINE YOU HAVE 100's of devices in the site and you need to configure the NTP servers. THERE's a better way.... with Ansible


## Installation

```
pushd ansible
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
ansible-galaxy install -r roles/requirements.yml
ansible-galaxy collection install git+https://github.com/nokia/srlinux-ansible-collection.git
popd
```

!! Need to add a step here to `sed` the correct IP into `/root/autocon2_workshop/ansible/inventory/netbox.yml`

## Usage

- Uses the local inventory: `ansible-inventory --list -i inventory/netbox.yml`
- Gets the NetBox inventory and caches it: `ansible-inventory --list`
- Set the hostname: ansible-playbook playbooks/set-hostname.yml
- Set the ntp servers (requires that you populate the custom field on the site): ansible-playbook playbooks/set-ntp.yml

## Other

- Some `nblookup` examples in Dave's infra playbooks: playbooks/create-do-vms.yml
- Lab with no NTP configuration: `./3_start_network.sh network/6.1_assurance/`
- To check ntp on the Nokia devices:
```
 A:clab-autocon2-srl1# info system ntp
    system {
        ntp {
            admin-state enable
            network-instance default
            server 0.pool.ntp.org {
            }
            server 1.pool.ntp.org {
            }
        }
    }
```
