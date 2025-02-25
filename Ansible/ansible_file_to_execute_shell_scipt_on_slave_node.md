
# Overview of Ansible Playbook

This Ansible playbook installs Docker on a remote server. It does so by using an install script, which is dynamically handled through the `script_path` variable. The playbook performs three main tasks: extracting the script name, copying the script to the remote server, and executing the script on the server.

## Breakdown of Each Section

### 1. Play Definition
```md
```yaml
- name: Install Docker on the remote server
  hosts: webserver
  become: yes  # Ensure tasks run with sudo privileges
```

- **name**: The name of the playbook. This is simply a description of the task being performed. In this case, it’s "Install Docker on the remote server."
- **hosts**: Specifies the group of remote machines (or hosts) that the playbook will target. In this case, it’s the `webserver` group. This can refer to a list of servers in the Ansible inventory.
- **become**: A directive to run the tasks with elevated privileges (sudo). This ensures that the tasks run as a superuser, which is often necessary for system-level changes, such as installing software.

### 2. First Task: Extract the Script Name

```yaml
- name: Extract script name from the path
  set_fact:
    script_name: "{{ script_path | basename }}"
```

- **name**: Describes what this task is doing: "Extract script name from the path."
- **set_fact**: This module allows setting new variables dynamically during the execution of the playbook. In this case, it's creating a new variable called `script_name`.
- **script_name**: `{{ script_path | basename }}` The `basename` filter is used to extract just the file name (without the directory path) from the `script_path` variable. For example, if `script_path` is `/home/user/install.sh`, `script_name` will be `install.sh`.

### 3. Second Task: Copy the Script to the Remote Server

```yaml
- name: Copy the install script to the remote server
  ansible.builtin.copy:
    src: "{{ script_path }}"   # The dynamic source path passed as a variable
    dest: "/tmp/{{ script_name }}"      # Dynamic script name extracted from the script_path
    mode: '0755'                      # Ensure it is executable on the remote server
```

- **name**: Describes what this task is doing: "Copy the install script to the remote server."
- **ansible.builtin.copy**: This is an Ansible module that copies files to remote hosts. It's one of the standard Ansible modules.
- **src**: `{{ script_path }}` Specifies the source file to copy. `script_path` is a variable that should be defined earlier (before or outside the playbook), containing the local path to the script that needs to be copied.
- **dest**: `"/tmp/{{ script_name }}"` Defines the destination path on the remote server. It uses the `script_name` variable (which was set in the previous task) to ensure that the file gets placed with its correct name, under `/tmp/`.
- **mode**: `'0755'` This sets the file permissions on the copied file. `0755` means the owner can read/write/execute, and others can read and execute the file. This ensures the script is executable on the remote server.

### 4. Third Task: Execute the Script

```yaml
- name: Execute the install script
  ansible.builtin.shell: "/tmp/{{ script_name }}"   # Run the dynamically named script on the remote server
```

- **name**: Describes what this task is doing: "Execute the install script."
- **ansible.builtin.shell**: This module runs shell commands on the remote host. In this case, it will execute the install script.
- **/tmp/{{ script_name }}**: This is the command to execute the script. It refers to the location where the script was copied (`/tmp/`) and uses the dynamic `script_name` to ensure that the correct script is executed.


# Playbook
```
---
- name: Install Docker on the remote server
  hosts: webserver
  become: yes  # Ensure tasks run with sudo privileges
  tasks:
    - name: Extract script name from the path
      set_fact:
        script_name: "{{ script_path | basename }}"

    - name: Copy the install script to the remote server
      ansible.builtin.copy:
        src: "{{ script_path }}"   # The dynamic source path passed as a variable
        dest: "/tmp/{{ script_name }}"      # Dynamic script name extracted from the script_path
        mode: '0755'                      # Ensure it is executable on the remote server

    - name: Execute the install script
      ansible.builtin.shell: "/tmp/{{ script_name }}"   # Run the dynamically named script on the remote server

```



#  Inventory File  (`hosts.ini`)
```md
```ini

[webserver]

18.206.245.186
34.230.89.29
```


- Ansible will **connect to**:
  - `18.206.245.186`
  - `34.230.89.29`
- and execute the tasks defined in `dynamic_path.yml`.



# **Objective of `installdocker.sh` Shell Script**

```sh
#!/bin/bash

# Step 1: Update the system package list
echo "Updating package list..."
sudo apt-get update -y

# Step 2: Install required dependencies
echo "Installing dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Step 3: Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Step 4: Set up Docker stable repository
echo "Setting up Docker repository..."
# Automatically accept the repository addition without asking for user confirmation
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

# Step 5: Update the package list again to include Docker packages
echo "Updating package list again..."
sudo apt-get update -y

# Step 6: Install Docker Community Edition (CE)
echo "Installing Docker..."
# Use non-interactive mode to prevent prompts during the install
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce

# Step 7: Start Docker and enable it to start on boot
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Step 8: Verify Docker installation
echo "Verifying Docker installation..."
sudo docker --version

# Step 9: Add user to Docker group (optional)
# This allows the user to run Docker commands without sudo
echo "Adding user to the docker group..."
sudo usermod -aG docker $USER

# Step 10: Print completion message
echo "Docker has been installed successfully!"
```
The script automates the installation of Docker on an Ubuntu-based system. 

---

# **Complete Ansible Command to Run the Playbook**

To execute an Ansible playbook (`dynamic_path.yml`) that runs this shell script on remote hosts, use:

```sh
ansible-playbook -i hosts.ini dynamic_path.yml -e "script_path=/home/ubuntu/installdocker.sh" -vvv
```

### **Explanation of the Command:**
`ansible-playbook`: Runs an Ansible playbook.
`-i hosts.ini`: Specifies the inventory file (hosts.ini).
`dynamic_path.yml`: The playbook that will execute `installdocker.sh`.
`-e "script_path=/home/ubuntu/installdocker.sh"`:
Passes script_path as an extra variable (-e) to specify the location of installdocker.sh on the remote host.
`-vvv`: Enables very verbose mode for debugging.


## **Output**:
```md

TASK [Execute the install script] ******************************************************************************
task path: /home/ubuntu/dynamic_path.yml:16
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<18.206.245.186> (0, b'/home/ubuntu\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836 `" && echo ansible-tmp-1740510502.357093-7365-125370407667836="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836 `" ) && sleep 0'"'"''
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<34.230.89.29> (0, b'/home/ubuntu\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353 `" && echo ansible-tmp-1740510502.3753805-7366-97887919816353="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353 `" ) && sleep 0'"'"''
<18.206.245.186> (0, b'ansible-tmp-1740510502.357093-7365-125370407667836=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836\n', b'')
<34.230.89.29> (0, b'ansible-tmp-1740510502.3753805-7366-97887919816353=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353\n', b'')
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<18.206.245.186> PUT /home/ubuntu/.ansible/tmp/ansible-local-7309z1l0n_10/tmpfe56lq4b TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/AnsiballZ_command.py
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<18.206.245.186> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' '[18.206.245.186]'
<34.230.89.29> PUT /home/ubuntu/.ansible/tmp/ansible-local-7309z1l0n_10/tmpxafjito0 TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/AnsiballZ_command.py
<34.230.89.29> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' '[34.230.89.29]'
<18.206.245.186> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7309z1l0n_10/tmpfe56lq4b /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/AnsiballZ_command.py\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/AnsiballZ_command.py && sleep 0'"'"''
<34.230.89.29> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7309z1l0n_10/tmpxafjito0 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/AnsiballZ_command.py\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/AnsiballZ_command.py && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' -tt 18.206.245.186 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-jujzduwtjdjqqrixiuevrfpvprvglpih ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' -tt 34.230.89.29 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-tcyqiplhecaumikyswzdlvtjxhvcabti ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
Escalation succeeded
Escalation succeeded
<34.230.89.29> (0, b'\r\n{"changed": true, "stdout": "Updating package list...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\\nReading package lists...\\nInstalling dependencies...\\nReading package lists...\\nBuilding dependency tree...\\nReading state information...\\napt-transport-https is already the newest version (2.7.14build2).\\nca-certificates is already the newest version (20240203).\\ncurl is already the newest version (8.5.0-2ubuntu10.6).\\nsoftware-properties-common is already the newest version (0.99.49.1).\\n0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.\\nAdding Docker\'s official GPG key...\\nOK\\nSetting up Docker repository...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\\nGet:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]\\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]\\nFetched 68.5 kB in 1s (92.5 kB/s)\\nReading package lists...\\nRepository: \'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable\'\\nDescription:\\nArchive for codename: noble components: stable\\nMore info: https://download.docker.com/linux/ubuntu\\nAdding repository.\\nAdding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\\nAdding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\\nUpdating package list again...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 https://download.docker.com/linux/ubuntu noble InRelease\\nHit:5 http://security.ubuntu.com/ubuntu noble-security InRelease\\nReading package lists...\\nInstalling Docker...\\nReading package lists...\\nBuilding dependency tree...\\nReading state information...\\nThe following additional packages will be installed:\\n  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras\\n  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns\\nSuggested packages:\\n  cgroupfs-mount | cgroup-lite\\nThe following NEW packages will be installed:\\n  containerd.io docker-buildx-plugin docker-ce docker-ce-cli\\n  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz\\n  slirp4netns\\n0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.\\nNeed to get 120 MB of archives.\\nAfter this operation, 437 MB of additional disk space will be used.\\nGet:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]\\nGet:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]\\nGet:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]\\nGet:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]\\nGet:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]\\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]\\nGet:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]\\nGet:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]\\nGet:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]\\nGet:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]\\nFetched 120 MB in 2s (56.0 MB/s)\\nSelecting previously unselected package pigz.\\r\\n(Reading database ... \\r(Reading database ... 5%\\r(Reading database ... 10%\\r(Reading database ... 15%\\r(Reading database ... 20%\\r(Reading database ... 25%\\r(Reading database ... 30%\\r(Reading database ... 35%\\r(Reading database ... 40%\\r(Reading database ... 45%\\r(Reading database ... 50%\\r(Reading database ... 55%\\r(Reading database ... 60%\\r(Reading database ... 65%\\r(Reading database ... 70%\\r(Reading database ... 75%\\r(Reading database ... 80%\\r(Reading database ... 85%\\r(Reading database ... 90%\\r(Reading database ... 95%\\r(Reading database ... 100%\\r(Reading database ... 70614 files and directories currently installed.)\\r\\nPreparing to unpack .../0-pigz_2.8-1_amd64.deb ...\\r\\nUnpacking pigz (2.8-1) ...\\r\\nSelecting previously unselected package containerd.io.\\r\\nPreparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...\\r\\nUnpacking containerd.io (1.7.25-1) ...\\r\\nSelecting previously unselected package docker-buildx-plugin.\\r\\nPreparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce-cli.\\r\\nPreparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce.\\r\\nPreparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce-rootless-extras.\\r\\nPreparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-compose-plugin.\\r\\nPreparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package libltdl7:amd64.\\r\\nPreparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...\\r\\nUnpacking libltdl7:amd64 (2.4.7-7build1) ...\\r\\nSelecting previously unselected package libslirp0:amd64.\\r\\nPreparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...\\r\\nUnpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...\\r\\nSelecting previously unselected package slirp4netns.\\r\\nPreparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...\\r\\nUnpacking slirp4netns (1.2.1-1build2) ...\\r\\nSetting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up containerd.io (1.7.25-1) ...\\r\\nCreated symlink /etc/systemd/system/multi-user.target.wants/containerd.service \\u2192 /usr/lib/systemd/system/containerd.service.\\r\\r\\nSetting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up libltdl7:amd64 (2.4.7-7build1) ...\\r\\nSetting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up libslirp0:amd64 (4.7.0-1ubuntu3) ...\\r\\nSetting up pigz (2.8-1) ...\\r\\nSetting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up slirp4netns (1.2.1-1build2) ...\\r\\nSetting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nCreated symlink /etc/systemd/system/multi-user.target.wants/docker.service \\u2192 /usr/lib/systemd/system/docker.service.\\r\\r\\nCreated symlink /etc/systemd/system/sockets.target.wants/docker.socket \\u2192 /usr/lib/systemd/system/docker.socket.\\r\\r\\nProcessing triggers for man-db (2.12.0-4build2) ...\\r\\nProcessing triggers for libc-bin (2.39-0ubuntu8.3) ...\\r\\n\\nRunning kernel seems to be up-to-date.\\n\\nNo services need to be restarted.\\n\\nNo containers need to be restarted.\\n\\nNo user sessions are running outdated binaries.\\n\\nNo VM guests are running outdated hypervisor (qemu) binaries on this host.\\nStarting Docker service...\\nVerifying Docker installation...\\nDocker version 28.0.0, build f9ced58\\nAdding user to the docker group...\\nDocker has been installed successfully!", "stderr": "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).\\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\\nSynchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.\\nExecuting: /usr/lib/systemd/systemd-sysv-install enable docker", "rc": 0, "cmd": "/tmp/installdocker.sh", "start": "2025-02-25 19:08:22.739387", "end": "2025-02-25 19:08:55.620546", "delta": "0:00:32.881159", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/installdocker.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 34.230.89.29 closed.\r\n')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.3753805-7366-97887919816353/ > /dev/null 2>&1 && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
changed: [34.230.89.29] => {
    "changed": true,
    "cmd": "/tmp/installdocker.sh",
    "delta": "0:00:32.881159",
    "end": "2025-02-25 19:08:55.620546",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/installdocker.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:08:22.739387",
    "stderr": "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\nSynchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.\nExecuting: /usr/lib/systemd/systemd-sysv-install enable docker",
    "stderr_lines": [
        "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).",
        "W: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.",
        "W: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.",
        "Synchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.",
        "Executing: /usr/lib/systemd/systemd-sysv-install enable docker"
    ],
    "stdout": "Updating package list...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\nReading package lists...\nInstalling dependencies...\nReading package lists...\nBuilding dependency tree...\nReading state information...\napt-transport-https is already the newest version (2.7.14build2).\nca-certificates is already the newest version (20240203).\ncurl is already the newest version (8.5.0-2ubuntu10.6).\nsoftware-properties-common is already the newest version (0.99.49.1).\n0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.\nAdding Docker's official GPG key...\nOK\nSetting up Docker repository...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\nGet:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]\nFetched 68.5 kB in 1s (92.5 kB/s)\nReading package lists...\nRepository: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable'\nDescription:\nArchive for codename: noble components: stable\nMore info: https://download.docker.com/linux/ubuntu\nAdding repository.\nAdding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\nAdding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\nUpdating package list again...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 https://download.docker.com/linux/ubuntu noble InRelease\nHit:5 http://security.ubuntu.com/ubuntu noble-security InRelease\nReading package lists...\nInstalling Docker...\nReading package lists...\nBuilding dependency tree...\nReading state information...\nThe following additional packages will be installed:\n  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras\n  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns\nSuggested packages:\n  cgroupfs-mount | cgroup-lite\nThe following NEW packages will be installed:\n  containerd.io docker-buildx-plugin docker-ce docker-ce-cli\n  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz\n  slirp4netns\n0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.\nNeed to get 120 MB of archives.\nAfter this operation, 437 MB of additional disk space will be used.\nGet:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]\nGet:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]\nGet:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]\nGet:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]\nGet:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]\nGet:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]\nGet:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]\nGet:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]\nGet:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]\nFetched 120 MB in 2s (56.0 MB/s)\nSelecting previously unselected package pigz.\r\n(Reading database ... \r(Reading database ... 5%\r(Reading database ... 10%\r(Reading database ... 15%\r(Reading database ... 20%\r(Reading database ... 25%\r(Reading database ... 30%\r(Reading database ... 35%\r(Reading database ... 40%\r(Reading database ... 45%\r(Reading database ... 50%\r(Reading database ... 55%\r(Reading database ... 60%\r(Reading database ... 65%\r(Reading database ... 70%\r(Reading database ... 75%\r(Reading database ... 80%\r(Reading database ... 85%\r(Reading database ... 90%\r(Reading database ... 95%\r(Reading database ... 100%\r(Reading database ... 70614 files and directories currently installed.)\r\nPreparing to unpack .../0-pigz_2.8-1_amd64.deb ...\r\nUnpacking pigz (2.8-1) ...\r\nSelecting previously unselected package containerd.io.\r\nPreparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...\r\nUnpacking containerd.io (1.7.25-1) ...\r\nSelecting previously unselected package docker-buildx-plugin.\r\nPreparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce-cli.\r\nPreparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce.\r\nPreparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce-rootless-extras.\r\nPreparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-compose-plugin.\r\nPreparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package libltdl7:amd64.\r\nPreparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...\r\nUnpacking libltdl7:amd64 (2.4.7-7build1) ...\r\nSelecting previously unselected package libslirp0:amd64.\r\nPreparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...\r\nUnpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...\r\nSelecting previously unselected package slirp4netns.\r\nPreparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...\r\nUnpacking slirp4netns (1.2.1-1build2) ...\r\nSetting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\r\nSetting up containerd.io (1.7.25-1) ...\r\nCreated symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.\r\r\nSetting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\r\nSetting up libltdl7:amd64 (2.4.7-7build1) ...\r\nSetting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSetting up libslirp0:amd64 (4.7.0-1ubuntu3) ...\r\nSetting up pigz (2.8-1) ...\r\nSetting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSetting up slirp4netns (1.2.1-1build2) ...\r\nSetting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nCreated symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.\r\r\nCreated symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.\r\r\nProcessing triggers for man-db (2.12.0-4build2) ...\r\nProcessing triggers for libc-bin (2.39-0ubuntu8.3) ...\r\n\nRunning kernel seems to be up-to-date.\n\nNo services need to be restarted.\n\nNo containers need to be restarted.\n\nNo user sessions are running outdated binaries.\n\nNo VM guests are running outdated hypervisor (qemu) binaries on this host.\nStarting Docker service...\nVerifying Docker installation...\nDocker version 28.0.0, build f9ced58\nAdding user to the docker group...\nDocker has been installed successfully!",
    "stdout_lines": [
        "Updating package list...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Reading package lists...",
        "Installing dependencies...",
        "Reading package lists...",
        "Building dependency tree...",
        "Reading state information...",
        "apt-transport-https is already the newest version (2.7.14build2).",
        "ca-certificates is already the newest version (20240203).",
        "curl is already the newest version (8.5.0-2ubuntu10.6).",
        "software-properties-common is already the newest version (0.99.49.1).",
        "0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.",
        "Adding Docker's official GPG key...",
        "OK",
        "Setting up Docker repository...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Get:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]",
        "Get:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]",
        "Fetched 68.5 kB in 1s (92.5 kB/s)",
        "Reading package lists...",
        "Repository: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable'",
        "Description:",
        "Archive for codename: noble components: stable",
        "More info: https://download.docker.com/linux/ubuntu",
        "Adding repository.",
        "Adding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list",
        "Adding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list",
        "Updating package list again...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 https://download.docker.com/linux/ubuntu noble InRelease",
        "Hit:5 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Reading package lists...",
        "Installing Docker...",
        "Reading package lists...",
        "Building dependency tree...",
        "Reading state information...",
        "The following additional packages will be installed:",
        "  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras",
        "  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns",
        "Suggested packages:",
        "  cgroupfs-mount | cgroup-lite",
        "The following NEW packages will be installed:",
        "  containerd.io docker-buildx-plugin docker-ce docker-ce-cli",
        "  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz",
        "  slirp4netns",
        "0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.",
        "Need to get 120 MB of archives.",
        "After this operation, 437 MB of additional disk space will be used.",
        "Get:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]",
        "Get:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]",
        "Get:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]",
        "Get:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]",
        "Get:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]",
        "Get:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]",
        "Get:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]",
        "Get:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]",
        "Get:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]",
        "Get:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]",
        "Fetched 120 MB in 2s (56.0 MB/s)",
        "Selecting previously unselected package pigz.",
        "(Reading database ... ",
        "(Reading database ... 5%",
        "(Reading database ... 10%",
        "(Reading database ... 15%",
        "(Reading database ... 20%",
        "(Reading database ... 25%",
        "(Reading database ... 30%",
        "(Reading database ... 35%",
        "(Reading database ... 40%",
        "(Reading database ... 45%",
        "(Reading database ... 50%",
        "(Reading database ... 55%",
        "(Reading database ... 60%",
        "(Reading database ... 65%",
        "(Reading database ... 70%",
        "(Reading database ... 75%",
        "(Reading database ... 80%",
        "(Reading database ... 85%",
        "(Reading database ... 90%",
        "(Reading database ... 95%",
        "(Reading database ... 100%",
        "(Reading database ... 70614 files and directories currently installed.)",
        "Preparing to unpack .../0-pigz_2.8-1_amd64.deb ...",
        "Unpacking pigz (2.8-1) ...",
        "Selecting previously unselected package containerd.io.",
        "Preparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...",
        "Unpacking containerd.io (1.7.25-1) ...",
        "Selecting previously unselected package docker-buildx-plugin.",
        "Preparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce-cli.",
        "Preparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce.",
        "Preparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce-rootless-extras.",
        "Preparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-compose-plugin.",
        "Preparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package libltdl7:amd64.",
        "Preparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...",
        "Unpacking libltdl7:amd64 (2.4.7-7build1) ...",
        "Selecting previously unselected package libslirp0:amd64.",
        "Preparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...",
        "Unpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...",
        "Selecting previously unselected package slirp4netns.",
        "Preparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...",
        "Unpacking slirp4netns (1.2.1-1build2) ...",
        "Setting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...",
        "Setting up containerd.io (1.7.25-1) ...",
        "Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.",
        "",
        "Setting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...",
        "Setting up libltdl7:amd64 (2.4.7-7build1) ...",
        "Setting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Setting up libslirp0:amd64 (4.7.0-1ubuntu3) ...",
        "Setting up pigz (2.8-1) ...",
        "Setting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Setting up slirp4netns (1.2.1-1build2) ...",
        "Setting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.",
        "",
        "Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.",
        "",
        "Processing triggers for man-db (2.12.0-4build2) ...",
        "Processing triggers for libc-bin (2.39-0ubuntu8.3) ...",
        "",
        "Running kernel seems to be up-to-date.",
        "",
        "No services need to be restarted.",
        "",
        "No containers need to be restarted.",
        "",
        "No user sessions are running outdated binaries.",
        "",
        "No VM guests are running outdated hypervisor (qemu) binaries on this host.",
        "Starting Docker service...",
        "Verifying Docker installation...",
        "Docker version 28.0.0, build f9ced58",
        "Adding user to the docker group...",
        "Docker has been installed successfully!"
    ]
}
<18.206.245.186> (0, b'\r\n{"changed": true, "stdout": "Updating package list...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\\nReading package lists...\\nInstalling dependencies...\\nReading package lists...\\nBuilding dependency tree...\\nReading state information...\\napt-transport-https is already the newest version (2.7.14build2).\\nca-certificates is already the newest version (20240203).\\ncurl is already the newest version (8.5.0-2ubuntu10.6).\\nsoftware-properties-common is already the newest version (0.99.49.1).\\n0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.\\nAdding Docker\'s official GPG key...\\nOK\\nSetting up Docker repository...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\\nGet:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]\\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]\\nFetched 68.5 kB in 1s (91.7 kB/s)\\nReading package lists...\\nRepository: \'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable\'\\nDescription:\\nArchive for codename: noble components: stable\\nMore info: https://download.docker.com/linux/ubuntu\\nAdding repository.\\nAdding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\\nAdding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\\nUpdating package list again...\\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\\nHit:5 https://download.docker.com/linux/ubuntu noble InRelease\\nReading package lists...\\nInstalling Docker...\\nReading package lists...\\nBuilding dependency tree...\\nReading state information...\\nThe following additional packages will be installed:\\n  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras\\n  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns\\nSuggested packages:\\n  cgroupfs-mount | cgroup-lite\\nThe following NEW packages will be installed:\\n  containerd.io docker-buildx-plugin docker-ce docker-ce-cli\\n  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz\\n  slirp4netns\\n0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.\\nNeed to get 120 MB of archives.\\nAfter this operation, 437 MB of additional disk space will be used.\\nGet:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]\\nGet:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]\\nGet:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]\\nGet:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]\\nGet:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]\\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]\\nGet:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]\\nGet:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]\\nGet:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]\\nGet:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]\\nFetched 120 MB in 2s (65.5 MB/s)\\nSelecting previously unselected package pigz.\\r\\n(Reading database ... \\r(Reading database ... 5%\\r(Reading database ... 10%\\r(Reading database ... 15%\\r(Reading database ... 20%\\r(Reading database ... 25%\\r(Reading database ... 30%\\r(Reading database ... 35%\\r(Reading database ... 40%\\r(Reading database ... 45%\\r(Reading database ... 50%\\r(Reading database ... 55%\\r(Reading database ... 60%\\r(Reading database ... 65%\\r(Reading database ... 70%\\r(Reading database ... 75%\\r(Reading database ... 80%\\r(Reading database ... 85%\\r(Reading database ... 90%\\r(Reading database ... 95%\\r(Reading database ... 100%\\r(Reading database ... 70614 files and directories currently installed.)\\r\\nPreparing to unpack .../0-pigz_2.8-1_amd64.deb ...\\r\\nUnpacking pigz (2.8-1) ...\\r\\nSelecting previously unselected package containerd.io.\\r\\nPreparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...\\r\\nUnpacking containerd.io (1.7.25-1) ...\\r\\nSelecting previously unselected package docker-buildx-plugin.\\r\\nPreparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce-cli.\\r\\nPreparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce.\\r\\nPreparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-ce-rootless-extras.\\r\\nPreparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package docker-compose-plugin.\\r\\nPreparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...\\r\\nUnpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\\r\\nSelecting previously unselected package libltdl7:amd64.\\r\\nPreparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...\\r\\nUnpacking libltdl7:amd64 (2.4.7-7build1) ...\\r\\nSelecting previously unselected package libslirp0:amd64.\\r\\nPreparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...\\r\\nUnpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...\\r\\nSelecting previously unselected package slirp4netns.\\r\\nPreparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...\\r\\nUnpacking slirp4netns (1.2.1-1build2) ...\\r\\nSetting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up containerd.io (1.7.25-1) ...\\r\\nCreated symlink /etc/systemd/system/multi-user.target.wants/containerd.service \\u2192 /usr/lib/systemd/system/containerd.service.\\r\\r\\nSetting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up libltdl7:amd64 (2.4.7-7build1) ...\\r\\nSetting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up libslirp0:amd64 (4.7.0-1ubuntu3) ...\\r\\nSetting up pigz (2.8-1) ...\\r\\nSetting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nSetting up slirp4netns (1.2.1-1build2) ...\\r\\nSetting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\\r\\nCreated symlink /etc/systemd/system/multi-user.target.wants/docker.service \\u2192 /usr/lib/systemd/system/docker.service.\\r\\r\\nCreated symlink /etc/systemd/system/sockets.target.wants/docker.socket \\u2192 /usr/lib/systemd/system/docker.socket.\\r\\r\\nProcessing triggers for man-db (2.12.0-4build2) ...\\r\\nProcessing triggers for libc-bin (2.39-0ubuntu8.3) ...\\r\\n\\nRunning kernel seems to be up-to-date.\\n\\nNo services need to be restarted.\\n\\nNo containers need to be restarted.\\n\\nNo user sessions are running outdated binaries.\\n\\nNo VM guests are running outdated hypervisor (qemu) binaries on this host.\\nStarting Docker service...\\nVerifying Docker installation...\\nDocker version 28.0.0, build f9ced58\\nAdding user to the docker group...\\nDocker has been installed successfully!", "stderr": "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).\\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\\nSynchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.\\nExecuting: /usr/lib/systemd/systemd-sysv-install enable docker", "rc": 0, "cmd": "/tmp/installdocker.sh", "start": "2025-02-25 19:08:22.735308", "end": "2025-02-25 19:08:59.692327", "delta": "0:00:36.957019", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/installdocker.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 18.206.245.186 closed.\r\n')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510502.357093-7365-125370407667836/ > /dev/null 2>&1 && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
changed: [18.206.245.186] => {
    "changed": true,
    "cmd": "/tmp/installdocker.sh",
    "delta": "0:00:36.957019",
    "end": "2025-02-25 19:08:59.692327",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/installdocker.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:08:22.735308",
    "stderr": "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\nW: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.\nSynchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.\nExecuting: /usr/lib/systemd/systemd-sysv-install enable docker",
    "stderr_lines": [
        "Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).",
        "W: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.",
        "W: https://download.docker.com/linux/ubuntu/dists/noble/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.",
        "Synchronizing state of docker.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.",
        "Executing: /usr/lib/systemd/systemd-sysv-install enable docker"
    ],
    "stdout": "Updating package list...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\nReading package lists...\nInstalling dependencies...\nReading package lists...\nBuilding dependency tree...\nReading state information...\napt-transport-https is already the newest version (2.7.14build2).\nca-certificates is already the newest version (20240203).\ncurl is already the newest version (8.5.0-2ubuntu10.6).\nsoftware-properties-common is already the newest version (0.99.49.1).\n0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.\nAdding Docker's official GPG key...\nOK\nSetting up Docker repository...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\nGet:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]\nFetched 68.5 kB in 1s (91.7 kB/s)\nReading package lists...\nRepository: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable'\nDescription:\nArchive for codename: noble components: stable\nMore info: https://download.docker.com/linux/ubuntu\nAdding repository.\nAdding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\nAdding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list\nUpdating package list again...\nHit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease\nHit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease\nHit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease\nHit:4 http://security.ubuntu.com/ubuntu noble-security InRelease\nHit:5 https://download.docker.com/linux/ubuntu noble InRelease\nReading package lists...\nInstalling Docker...\nReading package lists...\nBuilding dependency tree...\nReading state information...\nThe following additional packages will be installed:\n  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras\n  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns\nSuggested packages:\n  cgroupfs-mount | cgroup-lite\nThe following NEW packages will be installed:\n  containerd.io docker-buildx-plugin docker-ce docker-ce-cli\n  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz\n  slirp4netns\n0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.\nNeed to get 120 MB of archives.\nAfter this operation, 437 MB of additional disk space will be used.\nGet:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]\nGet:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]\nGet:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]\nGet:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]\nGet:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]\nGet:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]\nGet:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]\nGet:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]\nGet:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]\nGet:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]\nFetched 120 MB in 2s (65.5 MB/s)\nSelecting previously unselected package pigz.\r\n(Reading database ... \r(Reading database ... 5%\r(Reading database ... 10%\r(Reading database ... 15%\r(Reading database ... 20%\r(Reading database ... 25%\r(Reading database ... 30%\r(Reading database ... 35%\r(Reading database ... 40%\r(Reading database ... 45%\r(Reading database ... 50%\r(Reading database ... 55%\r(Reading database ... 60%\r(Reading database ... 65%\r(Reading database ... 70%\r(Reading database ... 75%\r(Reading database ... 80%\r(Reading database ... 85%\r(Reading database ... 90%\r(Reading database ... 95%\r(Reading database ... 100%\r(Reading database ... 70614 files and directories currently installed.)\r\nPreparing to unpack .../0-pigz_2.8-1_amd64.deb ...\r\nUnpacking pigz (2.8-1) ...\r\nSelecting previously unselected package containerd.io.\r\nPreparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...\r\nUnpacking containerd.io (1.7.25-1) ...\r\nSelecting previously unselected package docker-buildx-plugin.\r\nPreparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce-cli.\r\nPreparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce.\r\nPreparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-ce-rootless-extras.\r\nPreparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package docker-compose-plugin.\r\nPreparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...\r\nUnpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\r\nSelecting previously unselected package libltdl7:amd64.\r\nPreparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...\r\nUnpacking libltdl7:amd64 (2.4.7-7build1) ...\r\nSelecting previously unselected package libslirp0:amd64.\r\nPreparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...\r\nUnpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...\r\nSelecting previously unselected package slirp4netns.\r\nPreparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...\r\nUnpacking slirp4netns (1.2.1-1build2) ...\r\nSetting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...\r\nSetting up containerd.io (1.7.25-1) ...\r\nCreated symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.\r\r\nSetting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...\r\nSetting up libltdl7:amd64 (2.4.7-7build1) ...\r\nSetting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSetting up libslirp0:amd64 (4.7.0-1ubuntu3) ...\r\nSetting up pigz (2.8-1) ...\r\nSetting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nSetting up slirp4netns (1.2.1-1build2) ...\r\nSetting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...\r\nCreated symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.\r\r\nCreated symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.\r\r\nProcessing triggers for man-db (2.12.0-4build2) ...\r\nProcessing triggers for libc-bin (2.39-0ubuntu8.3) ...\r\n\nRunning kernel seems to be up-to-date.\n\nNo services need to be restarted.\n\nNo containers need to be restarted.\n\nNo user sessions are running outdated binaries.\n\nNo VM guests are running outdated hypervisor (qemu) binaries on this host.\nStarting Docker service...\nVerifying Docker installation...\nDocker version 28.0.0, build f9ced58\nAdding user to the docker group...\nDocker has been installed successfully!",
    "stdout_lines": [
        "Updating package list...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Reading package lists...",
        "Installing dependencies...",
        "Reading package lists...",
        "Building dependency tree...",
        "Reading state information...",
        "apt-transport-https is already the newest version (2.7.14build2).",
        "ca-certificates is already the newest version (20240203).",
        "curl is already the newest version (8.5.0-2ubuntu10.6).",
        "software-properties-common is already the newest version (0.99.49.1).",
        "0 upgraded, 0 newly installed, 0 to remove and 106 not upgraded.",
        "Adding Docker's official GPG key...",
        "OK",
        "Setting up Docker repository...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Get:5 https://download.docker.com/linux/ubuntu noble InRelease [48.8 kB]",
        "Get:6 https://download.docker.com/linux/ubuntu noble/stable amd64 Packages [19.7 kB]",
        "Fetched 68.5 kB in 1s (91.7 kB/s)",
        "Reading package lists...",
        "Repository: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable'",
        "Description:",
        "Archive for codename: noble components: stable",
        "More info: https://download.docker.com/linux/ubuntu",
        "Adding repository.",
        "Adding deb entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list",
        "Adding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list",
        "Updating package list again...",
        "Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble InRelease",
        "Hit:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease",
        "Hit:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease",
        "Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease",
        "Hit:5 https://download.docker.com/linux/ubuntu noble InRelease",
        "Reading package lists...",
        "Installing Docker...",
        "Reading package lists...",
        "Building dependency tree...",
        "Reading state information...",
        "The following additional packages will be installed:",
        "  containerd.io docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras",
        "  docker-compose-plugin libltdl7 libslirp0 pigz slirp4netns",
        "Suggested packages:",
        "  cgroupfs-mount | cgroup-lite",
        "The following NEW packages will be installed:",
        "  containerd.io docker-buildx-plugin docker-ce docker-ce-cli",
        "  docker-ce-rootless-extras docker-compose-plugin libltdl7 libslirp0 pigz",
        "  slirp4netns",
        "0 upgraded, 10 newly installed, 0 to remove and 106 not upgraded.",
        "Need to get 120 MB of archives.",
        "After this operation, 437 MB of additional disk space will be used.",
        "Get:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 pigz amd64 2.8-1 [65.6 kB]",
        "Get:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libltdl7 amd64 2.4.7-7build1 [40.3 kB]",
        "Get:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/main amd64 libslirp0 amd64 4.7.0-1ubuntu3 [63.8 kB]",
        "Get:4 http://us-east-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 slirp4netns amd64 1.2.1-1build2 [34.9 kB]",
        "Get:5 https://download.docker.com/linux/ubuntu noble/stable amd64 containerd.io amd64 1.7.25-1 [29.6 MB]",
        "Get:6 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-buildx-plugin amd64 0.21.0-1~ubuntu.24.04~noble [35.3 MB]",
        "Get:7 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-cli amd64 5:28.0.0-1~ubuntu.24.04~noble [15.7 MB]",
        "Get:8 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce amd64 5:28.0.0-1~ubuntu.24.04~noble [19.1 MB]",
        "Get:9 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-ce-rootless-extras amd64 5:28.0.0-1~ubuntu.24.04~noble [6086 kB]",
        "Get:10 https://download.docker.com/linux/ubuntu noble/stable amd64 docker-compose-plugin amd64 2.33.0-1~ubuntu.24.04~noble [13.9 MB]",
        "Fetched 120 MB in 2s (65.5 MB/s)",
        "Selecting previously unselected package pigz.",
        "(Reading database ... ",
        "(Reading database ... 5%",
        "(Reading database ... 10%",
        "(Reading database ... 15%",
        "(Reading database ... 20%",
        "(Reading database ... 25%",
        "(Reading database ... 30%",
        "(Reading database ... 35%",
        "(Reading database ... 40%",
        "(Reading database ... 45%",
        "(Reading database ... 50%",
        "(Reading database ... 55%",
        "(Reading database ... 60%",
        "(Reading database ... 65%",
        "(Reading database ... 70%",
        "(Reading database ... 75%",
        "(Reading database ... 80%",
        "(Reading database ... 85%",
        "(Reading database ... 90%",
        "(Reading database ... 95%",
        "(Reading database ... 100%",
        "(Reading database ... 70614 files and directories currently installed.)",
        "Preparing to unpack .../0-pigz_2.8-1_amd64.deb ...",
        "Unpacking pigz (2.8-1) ...",
        "Selecting previously unselected package containerd.io.",
        "Preparing to unpack .../1-containerd.io_1.7.25-1_amd64.deb ...",
        "Unpacking containerd.io (1.7.25-1) ...",
        "Selecting previously unselected package docker-buildx-plugin.",
        "Preparing to unpack .../2-docker-buildx-plugin_0.21.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce-cli.",
        "Preparing to unpack .../3-docker-ce-cli_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce.",
        "Preparing to unpack .../4-docker-ce_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-ce-rootless-extras.",
        "Preparing to unpack .../5-docker-ce-rootless-extras_5%3a28.0.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package docker-compose-plugin.",
        "Preparing to unpack .../6-docker-compose-plugin_2.33.0-1~ubuntu.24.04~noble_amd64.deb ...",
        "Unpacking docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...",
        "Selecting previously unselected package libltdl7:amd64.",
        "Preparing to unpack .../7-libltdl7_2.4.7-7build1_amd64.deb ...",
        "Unpacking libltdl7:amd64 (2.4.7-7build1) ...",
        "Selecting previously unselected package libslirp0:amd64.",
        "Preparing to unpack .../8-libslirp0_4.7.0-1ubuntu3_amd64.deb ...",
        "Unpacking libslirp0:amd64 (4.7.0-1ubuntu3) ...",
        "Selecting previously unselected package slirp4netns.",
        "Preparing to unpack .../9-slirp4netns_1.2.1-1build2_amd64.deb ...",
        "Unpacking slirp4netns (1.2.1-1build2) ...",
        "Setting up docker-buildx-plugin (0.21.0-1~ubuntu.24.04~noble) ...",
        "Setting up containerd.io (1.7.25-1) ...",
        "Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.",
        "",
        "Setting up docker-compose-plugin (2.33.0-1~ubuntu.24.04~noble) ...",
        "Setting up libltdl7:amd64 (2.4.7-7build1) ...",
        "Setting up docker-ce-cli (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Setting up libslirp0:amd64 (4.7.0-1ubuntu3) ...",
        "Setting up pigz (2.8-1) ...",
        "Setting up docker-ce-rootless-extras (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Setting up slirp4netns (1.2.1-1build2) ...",
        "Setting up docker-ce (5:28.0.0-1~ubuntu.24.04~noble) ...",
        "Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.",
        "",
        "Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.",
        "",
        "Processing triggers for man-db (2.12.0-4build2) ...",
        "Processing triggers for libc-bin (2.39-0ubuntu8.3) ...",
        "",
        "Running kernel seems to be up-to-date.",
        "",
        "No services need to be restarted.",
        "",
        "No containers need to be restarted.",
        "",
        "No user sessions are running outdated binaries.",
        "",
        "No VM guests are running outdated hypervisor (qemu) binaries on this host.",
        "Starting Docker service...",
        "Verifying Docker installation...",
        "Docker version 28.0.0, build f9ced58",
        "Adding user to the docker group...",
        "Docker has been installed successfully!"
    ]
}

PLAY RECAP *****************************************************************************************************
18.206.245.186             : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
34.230.89.29               : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

## Now lets run a nginx container:

```sh

#!/bin/bash

# Step 1: Pull the latest NGINX Docker image
echo "Pulling the latest NGINX image from Docker Hub..."
docker pull nginx:latest

# Step 2: Run the NGINX container
echo "Running the NGINX container on port 80..."
docker run -d -p 80:80 --name nginx-container nginx:latest

# Step 3: Verify if the NGINX container is running
echo "Checking if the NGINX container is running..."
docker ps -f "name=nginx-container"

# Step 4: Print completion message
echo "NGINX is now running and accessible on localhost:80"
```
So this script will run a nginx containe on your slave nodes;

Output:

```md
TASK [Execute the install script] ******************************************************************************
task path: /home/ubuntu/dynamic_path.yml:16
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<18.206.245.186> (0, b'/home/ubuntu\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674 `" && echo ansible-tmp-1740510590.1636317-7453-206447829807674="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674 `" ) && sleep 0'"'"''
<34.230.89.29> (0, b'/home/ubuntu\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786 `" && echo ansible-tmp-1740510590.1793747-7454-126163755501786="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786 `" ) && sleep 0'"'"''
<18.206.245.186> (0, b'ansible-tmp-1740510590.1636317-7453-206447829807674=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674\n', b'')
<34.230.89.29> (0, b'ansible-tmp-1740510590.1793747-7454-126163755501786=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786\n', b'')
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<18.206.245.186> PUT /home/ubuntu/.ansible/tmp/ansible-local-7397_0i__c_a/tmpxh99a4p3 TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/AnsiballZ_command.py
<18.206.245.186> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' '[18.206.245.186]'
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<34.230.89.29> PUT /home/ubuntu/.ansible/tmp/ansible-local-7397_0i__c_a/tmprv2hcltz TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/AnsiballZ_command.py
<34.230.89.29> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' '[34.230.89.29]'
<18.206.245.186> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7397_0i__c_a/tmpxh99a4p3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/AnsiballZ_command.py\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/AnsiballZ_command.py && sleep 0'"'"''
<34.230.89.29> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7397_0i__c_a/tmprv2hcltz /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/AnsiballZ_command.py\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/AnsiballZ_command.py && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' -tt 34.230.89.29 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-khxiehbtveuqdlhfxelhlvwtgwymcffp ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' -tt 18.206.245.186 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-iyjhjdrkoushjrqqdgbqwzogutluhmsd ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
Escalation succeeded
Escalation succeeded
<34.230.89.29> (0, b'\r\n\r\n{"changed": true, "stdout": "Pulling the latest NGINX image from Docker Hub...\\nlatest: Pulling from library/nginx\\n7cf63256a31a: Pulling fs layer\\nbf9acace214a: Pulling fs layer\\n513c3649bb14: Pulling fs layer\\nd014f92d532d: Pulling fs layer\\n9dd21ad5a4a6: Pulling fs layer\\n943ea0f0c2e4: Pulling fs layer\\n103f50cb3e9f: Pulling fs layer\\nd014f92d532d: Waiting\\n9dd21ad5a4a6: Waiting\\n943ea0f0c2e4: Waiting\\n103f50cb3e9f: Waiting\\n513c3649bb14: Verifying Checksum\\n513c3649bb14: Download complete\\nd014f92d532d: Verifying Checksum\\nd014f92d532d: Download complete\\n7cf63256a31a: Verifying Checksum\\n7cf63256a31a: Download complete\\n943ea0f0c2e4: Verifying Checksum\\n943ea0f0c2e4: Download complete\\nbf9acace214a: Verifying Checksum\\nbf9acace214a: Download complete\\n9dd21ad5a4a6: Verifying Checksum\\n9dd21ad5a4a6: Download complete\\n103f50cb3e9f: Verifying Checksum\\n103f50cb3e9f: Download complete\\n7cf63256a31a: Pull complete\\nbf9acace214a: Pull complete\\n513c3649bb14: Pull complete\\nd014f92d532d: Pull complete\\n9dd21ad5a4a6: Pull complete\\n943ea0f0c2e4: Pull complete\\n103f50cb3e9f: Pull complete\\nDigest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496\\nStatus: Downloaded newer image for nginx:latest\\ndocker.io/library/nginx:latest\\nRunning the NGINX container on port 80...\\n7f2feb3260ade85461c01c0f7de395802236fda5e653d951fd10230afabfd0c9\\nChecking if the NGINX container is running...\\nCONTAINER ID   IMAGE          COMMAND                  CREATED        STATUS                  PORTS                                 NAMES\\n7f2feb3260ad   nginx:latest   \\"/docker-entrypoint.\\u2026\\"   1 second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\\nNGINX is now running and accessible on localhost:80", "stderr": "", "rc": 0, "cmd": "/tmp/nginx-dockerimage.sh", "start": "2025-02-25 19:09:50.554372", "end": "2025-02-25 19:09:55.443217", "delta": "0:00:04.888845", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/nginx-dockerimage.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 34.230.89.29 closed.\r\n')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1793747-7454-126163755501786/ > /dev/null 2>&1 && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
changed: [34.230.89.29] => {
    "changed": true,
    "cmd": "/tmp/nginx-dockerimage.sh",
    "delta": "0:00:04.888845",
    "end": "2025-02-25 19:09:55.443217",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/nginx-dockerimage.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:09:50.554372",
    "stderr": "",
    "stderr_lines": [],
    "stdout": "Pulling the latest NGINX image from Docker Hub...\nlatest: Pulling from library/nginx\n7cf63256a31a: Pulling fs layer\nbf9acace214a: Pulling fs layer\n513c3649bb14: Pulling fs layer\nd014f92d532d: Pulling fs layer\n9dd21ad5a4a6: Pulling fs layer\n943ea0f0c2e4: Pulling fs layer\n103f50cb3e9f: Pulling fs layer\nd014f92d532d: Waiting\n9dd21ad5a4a6: Waiting\n943ea0f0c2e4: Waiting\n103f50cb3e9f: Waiting\n513c3649bb14: Verifying Checksum\n513c3649bb14: Download complete\nd014f92d532d: Verifying Checksum\nd014f92d532d: Download complete\n7cf63256a31a: Verifying Checksum\n7cf63256a31a: Download complete\n943ea0f0c2e4: Verifying Checksum\n943ea0f0c2e4: Download complete\nbf9acace214a: Verifying Checksum\nbf9acace214a: Download complete\n9dd21ad5a4a6: Verifying Checksum\n9dd21ad5a4a6: Download complete\n103f50cb3e9f: Verifying Checksum\n103f50cb3e9f: Download complete\n7cf63256a31a: Pull complete\nbf9acace214a: Pull complete\n513c3649bb14: Pull complete\nd014f92d532d: Pull complete\n9dd21ad5a4a6: Pull complete\n943ea0f0c2e4: Pull complete\n103f50cb3e9f: Pull complete\nDigest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496\nStatus: Downloaded newer image for nginx:latest\ndocker.io/library/nginx:latest\nRunning the NGINX container on port 80...\n7f2feb3260ade85461c01c0f7de395802236fda5e653d951fd10230afabfd0c9\nChecking if the NGINX container is running...\nCONTAINER ID   IMAGE          COMMAND
       CREATED        STATUS                  PORTS                                 NAMES\n7f2feb3260ad   nginx:latest   \"/docker-entrypoint.…\"   1 second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\nNGINX is now running and accessible on localhost:80",
    "stdout_lines": [
        "Pulling the latest NGINX image from Docker Hub...",
        "latest: Pulling from library/nginx",
        "7cf63256a31a: Pulling fs layer",
        "bf9acace214a: Pulling fs layer",
        "513c3649bb14: Pulling fs layer",
        "d014f92d532d: Pulling fs layer",
        "9dd21ad5a4a6: Pulling fs layer",
        "943ea0f0c2e4: Pulling fs layer",
        "103f50cb3e9f: Pulling fs layer",
        "d014f92d532d: Waiting",
        "9dd21ad5a4a6: Waiting",
        "943ea0f0c2e4: Waiting",
        "103f50cb3e9f: Waiting",
        "513c3649bb14: Verifying Checksum",
        "513c3649bb14: Download complete",
        "d014f92d532d: Verifying Checksum",
        "d014f92d532d: Download complete",
        "7cf63256a31a: Verifying Checksum",
        "7cf63256a31a: Download complete",
        "943ea0f0c2e4: Verifying Checksum",
        "943ea0f0c2e4: Download complete",
        "bf9acace214a: Verifying Checksum",
        "bf9acace214a: Download complete",
        "9dd21ad5a4a6: Verifying Checksum",
        "9dd21ad5a4a6: Download complete",
        "103f50cb3e9f: Verifying Checksum",
        "103f50cb3e9f: Download complete",
        "7cf63256a31a: Pull complete",
        "bf9acace214a: Pull complete",
        "513c3649bb14: Pull complete",
        "d014f92d532d: Pull complete",
        "9dd21ad5a4a6: Pull complete",
        "943ea0f0c2e4: Pull complete",
        "103f50cb3e9f: Pull complete",
        "Digest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496",
        "Status: Downloaded newer image for nginx:latest",
        "docker.io/library/nginx:latest",
        "Running the NGINX container on port 80...",
        "7f2feb3260ade85461c01c0f7de395802236fda5e653d951fd10230afabfd0c9",
        "Checking if the NGINX container is running...",
        "CONTAINER ID   IMAGE          COMMAND                  CREATED        STATUS                  PORTS                                 NAMES",
        "7f2feb3260ad   nginx:latest   \"/docker-entrypoint.…\"   1 second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container",
        "NGINX is now running and accessible on localhost:80"
    ]
}
<18.206.245.186> (0, b'\r\n{"changed": true, "stdout": "Pulling the latest NGINX image from Docker Hub...\\nlatest: Pulling from library/nginx\\n7cf63256a31a: Pulling fs layer\\nbf9acace214a: Pulling fs layer\\n513c3649bb14: Pulling fs layer\\nd014f92d532d: Pulling fs layer\\n9dd21ad5a4a6: Pulling fs layer\\n943ea0f0c2e4: Pulling fs layer\\n103f50cb3e9f: Pulling fs layer\\nd014f92d532d: Waiting\\n9dd21ad5a4a6: Waiting\\n943ea0f0c2e4: Waiting\\n103f50cb3e9f: Waiting\\n513c3649bb14: Verifying Checksum\\n513c3649bb14: Download complete\\nd014f92d532d: Verifying Checksum\\nd014f92d532d: Download complete\\n9dd21ad5a4a6: Verifying Checksum\\n9dd21ad5a4a6: Download complete\\n943ea0f0c2e4: Verifying Checksum\\n943ea0f0c2e4: Download complete\\nbf9acace214a: Verifying Checksum\\nbf9acace214a: Download complete\\n103f50cb3e9f: Verifying Checksum\\n103f50cb3e9f: Download complete\\n7cf63256a31a: Verifying Checksum\\n7cf63256a31a: Download complete\\n7cf63256a31a: Pull complete\\nbf9acace214a: Pull complete\\n513c3649bb14: Pull complete\\nd014f92d532d: Pull complete\\n9dd21ad5a4a6: Pull complete\\n943ea0f0c2e4: Pull complete\\n103f50cb3e9f: Pull complete\\nDigest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496\\nStatus: Downloaded newer image for nginx:latest\\ndocker.io/library/nginx:latest\\nRunning the NGINX container on port 80...\\na623723eaea8740929dcdbdcf5c08e65bbb4bcb09f2625b8dcab15db7cd28804\\nChecking if the NGINX container is running...\\nCONTAINER ID   IMAGE          COMMAND                  CREATED
 STATUS                  PORTS                                 NAMES\\na623723eaea8   nginx:latest   \\"/docker-entrypoint.\\u2026\\"   Less than a second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\\nNGINX is now running and accessible on localhost:80", "stderr": "", "rc": 0, "cmd": "/tmp/nginx-dockerimage.sh", "start": "2025-02-25 19:09:50.553194", "end": "2025-02-25 19:09:55.797401", "delta": "0:00:05.244207", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/nginx-dockerimage.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 18.206.245.186 closed.\r\n')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510590.1636317-7453-206447829807674/ > /dev/null 2>&1 && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
changed: [18.206.245.186] => {
    "changed": true,
    "cmd": "/tmp/nginx-dockerimage.sh",
    "delta": "0:00:05.244207",
    "end": "2025-02-25 19:09:55.797401",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/nginx-dockerimage.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:09:50.553194",
    "stderr": "",
    "stderr_lines": [],
    "stdout": "Pulling the latest NGINX image from Docker Hub...\nlatest: Pulling from library/nginx\n7cf63256a31a: Pulling fs layer\nbf9acace214a: Pulling fs layer\n513c3649bb14: Pulling fs layer\nd014f92d532d: Pulling fs layer\n9dd21ad5a4a6: Pulling fs layer\n943ea0f0c2e4: Pulling fs layer\n103f50cb3e9f: Pulling fs layer\nd014f92d532d: Waiting\n9dd21ad5a4a6: Waiting\n943ea0f0c2e4: Waiting\n103f50cb3e9f: Waiting\n513c3649bb14: Verifying Checksum\n513c3649bb14: Download complete\nd014f92d532d: Verifying Checksum\nd014f92d532d: Download complete\n9dd21ad5a4a6: Verifying Checksum\n9dd21ad5a4a6: Download complete\n943ea0f0c2e4: Verifying Checksum\n943ea0f0c2e4: Download complete\nbf9acace214a: Verifying Checksum\nbf9acace214a: Download complete\n103f50cb3e9f: Verifying Checksum\n103f50cb3e9f: Download complete\n7cf63256a31a: Verifying Checksum\n7cf63256a31a: Download complete\n7cf63256a31a: Pull complete\nbf9acace214a: Pull complete\n513c3649bb14: Pull complete\nd014f92d532d: Pull complete\n9dd21ad5a4a6: Pull complete\n943ea0f0c2e4: Pull complete\n103f50cb3e9f: Pull complete\nDigest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496\nStatus: Downloaded newer image for nginx:latest\ndocker.io/library/nginx:latest\nRunning the NGINX container on port 80...\na623723eaea8740929dcdbdcf5c08e65bbb4bcb09f2625b8dcab15db7cd28804\nChecking if the NGINX container is running...\nCONTAINER ID   IMAGE          COMMAND
       CREATED                  STATUS                  PORTS                                 NAMES\na623723eaea8   nginx:latest   \"/docker-entrypoint.…\"   Less than a second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\nNGINX is now running and accessible on localhost:80",
    "stdout_lines": [
        "Pulling the latest NGINX image from Docker Hub...",
        "latest: Pulling from library/nginx",
        "7cf63256a31a: Pulling fs layer",
        "bf9acace214a: Pulling fs layer",
        "513c3649bb14: Pulling fs layer",
        "d014f92d532d: Pulling fs layer",
        "9dd21ad5a4a6: Pulling fs layer",
        "943ea0f0c2e4: Pulling fs layer",
        "103f50cb3e9f: Pulling fs layer",
        "d014f92d532d: Waiting",
        "9dd21ad5a4a6: Waiting",
        "943ea0f0c2e4: Waiting",
        "103f50cb3e9f: Waiting",
        "513c3649bb14: Verifying Checksum",
        "513c3649bb14: Download complete",
        "d014f92d532d: Verifying Checksum",
        "d014f92d532d: Download complete",
        "9dd21ad5a4a6: Verifying Checksum",
        "9dd21ad5a4a6: Download complete",
        "943ea0f0c2e4: Verifying Checksum",
        "943ea0f0c2e4: Download complete",
        "bf9acace214a: Verifying Checksum",
        "bf9acace214a: Download complete",
        "103f50cb3e9f: Verifying Checksum",
        "103f50cb3e9f: Download complete",
        "7cf63256a31a: Verifying Checksum",
        "7cf63256a31a: Download complete",
        "7cf63256a31a: Pull complete",
        "bf9acace214a: Pull complete",
        "513c3649bb14: Pull complete",
        "d014f92d532d: Pull complete",
        "9dd21ad5a4a6: Pull complete",
        "943ea0f0c2e4: Pull complete",
        "103f50cb3e9f: Pull complete",
        "Digest: sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496",
        "Status: Downloaded newer image for nginx:latest",
        "docker.io/library/nginx:latest",
        "Running the NGINX container on port 80...",
        "a623723eaea8740929dcdbdcf5c08e65bbb4bcb09f2625b8dcab15db7cd28804",
        "Checking if the NGINX container is running...",
        "CONTAINER ID   IMAGE          COMMAND                  CREATED                  STATUS                  PORTS                                 NAMES",
        "a623723eaea8   nginx:latest   \"/docker-entrypoint.…\"   Less than a second ago   Up Less than a second   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container",
        "NGINX is now running and accessible on localhost:80"
    ]
}

PLAY RECAP *****************************************************************************************************
18.206.245.186             : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
34.230.89.29               : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

# Now lets list containers and restart nginx container:

```sh
#!/bin/bash

# Step 1: List all Docker images
echo "Listing all Docker images..."
docker images

# Step 2: List all Docker containers (running and stopped)
echo "Listing all Docker containers..."
docker ps -a

# Step 3: Restart the Nginx Docker container (if it's running)
# Get the container ID or name for the running nginx container
nginx_container_id=$(docker ps -q -f "ancestor=nginx")

if [ -z "$nginx_container_id" ]; then
    echo "No running Nginx container found."
else
    echo "Restarting Nginx container with ID: $nginx_container_id..."
    docker restart $nginx_container_id
    echo "Nginx container restarted successfully."
fi
```

## Output:
```md

TASK [Execute the install script] ******************************************************************************
task path: /home/ubuntu/dynamic_path.yml:16
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<18.206.245.186> (0, b'/home/ubuntu\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940 `" && echo ansible-tmp-1740510754.36341-7529-37705463430940="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940 `" ) && sleep 0'"'"''
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<34.230.89.29> (0, b'/home/ubuntu\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/ubuntu/.ansible/tmp `"&& mkdir "` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904 `" && echo ansible-tmp-1740510754.383281-7530-255693701617904="` echo /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904 `" ) && sleep 0'"'"''
<18.206.245.186> (0, b'ansible-tmp-1740510754.36341-7529-37705463430940=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940\n', b'')
<34.230.89.29> (0, b'ansible-tmp-1740510754.383281-7530-255693701617904=/home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904\n', b'')
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<18.206.245.186> PUT /home/ubuntu/.ansible/tmp/ansible-local-7473ktpi7w9m/tmply1oxqyu TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/AnsiballZ_command.py
<18.206.245.186> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' '[18.206.245.186]'
Using module file /usr/lib/python3/dist-packages/ansible/modules/command.py
<34.230.89.29> PUT /home/ubuntu/.ansible/tmp/ansible-local-7473ktpi7w9m/tmpwlw_e5v3 TO /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/AnsiballZ_command.py
<34.230.89.29> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' '[34.230.89.29]'
<18.206.245.186> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7473ktpi7w9m/tmply1oxqyu /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/AnsiballZ_command.py\n', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/AnsiballZ_command.py && sleep 0'"'"''
<34.230.89.29> (0, b'sftp> put /home/ubuntu/.ansible/tmp/ansible-local-7473ktpi7w9m/tmpwlw_e5v3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/AnsiballZ_command.py\n', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'chmod u+x /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/ /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/AnsiballZ_command.py && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' -tt 18.206.245.186 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-jkkbupswhfllqujvewrxvhlcohmknosm ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' -tt 34.230.89.29 '/bin/sh -c '"'"'sudo -H -S -n  -u root /bin/sh -c '"'"'"'"'"'"'"'"'echo BECOME-SUCCESS-ramzpixmbrigbrregghaoblrfutkvxwd ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/AnsiballZ_command.py'"'"'"'"'"'"'"'"' && sleep 0'"'"''
Escalation succeeded
Escalation succeeded
<34.230.89.29> (0, b'\r\n{"changed": true, "stdout": "Listing all Docker images...\\nREPOSITORY   TAG       IMAGE ID       CREATED       SIZE\\nnginx        latest    b52e0b094bc0   2 weeks ago   192MB\\nListing all Docker containers...\\nCONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                 NAMES\\n7f2feb3260ad   nginx:latest   \\"/docker-entrypoint.\\u2026\\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\\nRestarting Nginx container with ID: 7f2feb3260ad...\\n7f2feb3260ad\\nNginx container restarted successfully.", "stderr": "", "rc": 0, "cmd": "/tmp/restartcontainer.sh", "start": "2025-02-25 19:12:34.747346", "end": "2025-02-25 19:12:35.193551", "delta": "0:00:00.446205", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/restartcontainer.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 34.230.89.29 closed.\r\n')
<34.230.89.29> ESTABLISH SSH CONNECTION FOR USER: None
<34.230.89.29> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/0aa6f68215"' 34.230.89.29 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.383281-7530-255693701617904/ > /dev/null 2>&1 && sleep 0'"'"''
<34.230.89.29> (0, b'', b'')
changed: [34.230.89.29] => {
    "changed": true,
    "cmd": "/tmp/restartcontainer.sh",
    "delta": "0:00:00.446205",
    "end": "2025-02-25 19:12:35.193551",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/restartcontainer.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:12:34.747346",
    "stderr": "",
    "stderr_lines": [],
    "stdout": "Listing all Docker images...\nREPOSITORY   TAG       IMAGE ID       CREATED       SIZE\nnginx        latest    b52e0b094bc0   2 weeks ago   192MB\nListing all Docker containers...\nCONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                 NAMES\n7f2feb3260ad   nginx:latest   \"/docker-entrypoint.…\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\nRestarting Nginx container with ID: 7f2feb3260ad...\n7f2feb3260ad\nNginx container restarted successfully.",
    "stdout_lines": [
        "Listing all Docker images...",
        "REPOSITORY   TAG       IMAGE ID       CREATED       SIZE",
        "nginx        latest    b52e0b094bc0   2 weeks ago   192MB",
        "Listing all Docker containers...",
        "CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS
                     NAMES",
        "7f2feb3260ad   nginx:latest   \"/docker-entrypoint.…\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container",
        "Restarting Nginx container with ID: 7f2feb3260ad...",
        "7f2feb3260ad",
        "Nginx container restarted successfully."
    ]
}
<18.206.245.186> (0, b'\r\n{"changed": true, "stdout": "Listing all Docker images...\\nREPOSITORY   TAG       IMAGE ID       CREATED       SIZE\\nnginx        latest    b52e0b094bc0   2 weeks ago   192MB\\nListing all Docker containers...\\nCONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                 NAMES\\na623723eaea8   nginx:latest   \\"/docker-entrypoint.\\u2026\\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\\nRestarting Nginx container with ID: a623723eaea8...\\na623723eaea8\\nNginx container restarted successfully.", "stderr": "", "rc": 0, "cmd": "/tmp/restartcontainer.sh", "start": "2025-02-25 19:12:34.749745", "end": "2025-02-25 19:12:35.264647", "delta": "0:00:00.514902", "msg": "", "invocation": {"module_args": {"_raw_params": "/tmp/restartcontainer.sh", "_uses_shell": true, "expand_argument_vars": true, "stdin_add_newline": true, "strip_empty_ends": true, "argv": null, "chdir": null, "executable": null, "creates": null, "removes": null, "stdin": null}}}\r\n', b'Shared connection to 18.206.245.186 closed.\r\n')
<18.206.245.186> ESTABLISH SSH CONNECTION FOR USER: None
<18.206.245.186> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o 'ControlPath="/home/ubuntu/.ansible/cp/9f1d7dd849"' 18.206.245.186 '/bin/sh -c '"'"'rm -f -r /home/ubuntu/.ansible/tmp/ansible-tmp-1740510754.36341-7529-37705463430940/ > /dev/null 2>&1 && sleep 0'"'"''
<18.206.245.186> (0, b'', b'')
changed: [18.206.245.186] => {
    "changed": true,
    "cmd": "/tmp/restartcontainer.sh",
    "delta": "0:00:00.514902",
    "end": "2025-02-25 19:12:35.264647",
    "invocation": {
        "module_args": {
            "_raw_params": "/tmp/restartcontainer.sh",
            "_uses_shell": true,
            "argv": null,
            "chdir": null,
            "creates": null,
            "executable": null,
            "expand_argument_vars": true,
            "removes": null,
            "stdin": null,
            "stdin_add_newline": true,
            "strip_empty_ends": true
        }
    },
    "msg": "",
    "rc": 0,
    "start": "2025-02-25 19:12:34.749745",
    "stderr": "",
    "stderr_lines": [],
    "stdout": "Listing all Docker images...\nREPOSITORY   TAG       IMAGE ID       CREATED       SIZE\nnginx        latest    b52e0b094bc0   2 weeks ago   192MB\nListing all Docker containers...\nCONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                 NAMES\na623723eaea8   nginx:latest   \"/docker-entrypoint.…\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container\nRestarting Nginx container with ID: a623723eaea8...\na623723eaea8\nNginx container restarted successfully.",
    "stdout_lines": [
        "Listing all Docker images...",
        "REPOSITORY   TAG       IMAGE ID       CREATED       SIZE",
        "nginx        latest    b52e0b094bc0   2 weeks ago   192MB",
        "Listing all Docker containers...",
        "CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS
                     NAMES",
        "a623723eaea8   nginx:latest   \"/docker-entrypoint.…\"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   nginx-container",
        "Restarting Nginx container with ID: a623723eaea8...",
        "a623723eaea8",
        "Nginx container restarted successfully."
    ]
}

PLAY RECAP *****************************************************************************************************
18.206.245.186             : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
34.230.89.29               : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
