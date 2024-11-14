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
