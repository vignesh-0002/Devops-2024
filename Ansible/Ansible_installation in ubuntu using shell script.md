## Steps to install ansible using shell on ubuntu:
- Below is a simple shell script that you can use to install Ansible on an Ubuntu machine.
  
```
#!/bin/bash

# Update the system
echo "Updating package lists..."
sudo apt-get update

# Install required dependencies
echo "Installing software-properties-common..."
sudo apt-get install -y software-properties-common

# Add the Ansible PPA (Personal Package Archive)
echo "Adding Ansible PPA..."
sudo add-apt-repository ppa:ansible/ansible

# Update the package list again after adding the PPA
echo "Updating package lists after adding PPA..."
sudo apt-get update

# Install Ansible
echo "Installing Ansible..."
sudo apt-get install -y ansible

# Verify installation
echo "Verifying Ansible installation..."
ansible --version

echo "Ansible installation complete!"

```
## Instructions:
1. Save the script: Copy and paste the above script into a new file, e.g., install_ansible.sh.
2. Make it executable:
```
chmod +x install_ansible.sh
```
3. Run the script:
```
sudo ./install_ansible.sh
```

### Output:
```
ansible --version

ansible [core 2.17.7]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Nov  6 2024, 20:22:13) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```
