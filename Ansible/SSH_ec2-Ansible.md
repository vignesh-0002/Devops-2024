# 1. Enable Connectivity from Master to Slaves
## Public and Private Subnet Configuration
  - Public Subnet (Ansible Master Node):

      - Ensure the master node has a public IP or Elastic IP attached.
      - Allow inbound SSH access (Port 22) in the Security Group.
  - Private Subnet (Slave Nodes):
      - The private instances should have private IPs only.
      - Set up their Security Group to allow SSH traffic (Port 22) from the master node's private IP or Security Group.
   
## NAT Gateway/Instance (For Private Nodes Internet Access):
   - If the private instances need internet access (e.g., for updates or package installations):
       - Configure a NAT Gateway in the public subnet.
       - Update the private subnet's route table to direct internet-bound traffic to the NAT Gateway.
# 2. SSH Key Pair Setup
## Generate SSH Key Pair on Master Node
 1. On the Ansible master node:

        ssh-keygen -t rsa -b 2048 -f ~/.ssh/ansible-key
    - Save the key pair in `~/.ssh/ansible-key` and `~/.ssh/ansible-key.pub`.
## Copy Public Key to Slaves
  - Use ssh-copy-id or manually add the public key to each slave node.
  - Run:

        ssh-copy-id -i ~/.ssh/ansible-key.pub ubuntu@<private-slave-ip>
   - If ssh-copy-id is unavailable:

         cat ~/.ssh/ansible-key.pub | ssh ubuntu@<private-slave-ip> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
# 3. Configure Ansible Inventory

## Example Inventory File (inventory.yml):
```
all:
  children:
    slaves:
      hosts:
        slave-1:
          ansible_host: <private-ip-of-slave-1>
        slave-2:
          ansible_host: <private-ip-of-slave-2>
        slave-3:
          ansible_host: <private-ip-of-slave-3>
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ~/.ssh/ansible-key

```
#   4. Test SSH Connectivity

## From the master node:
        ssh -i ~/.ssh/ansible-key ubuntu@<private-ip-of-slave>

  - If successful, Ansible should also work.

# 5. Set Up Ansible Configuration
## Ansible Configuration File (ansible.cfg):

```
[defaults]
inventory = inventory.yml
private_key_file = ~/.ssh/ansible-key
host_key_checking = False

```
