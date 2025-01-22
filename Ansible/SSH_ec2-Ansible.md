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
