# Steps to Create an SSH Connection from Local Machine to Remote Machine

## Step 1: Install and Verify SSH
### On Local Machine:
1. Check if SSH is installed:
   
              ssh -V
3. If not installed:
    - Ubuntu/Debian:
      
               sudo apt update && sudo apt install openssh-client
    - MacOS: SSH is pre-installed.
    - Windows: Use PowerShell, WSL, or install PuTTY.
### On Remote Machine:
 1. Check if SSH server is installed and running:
    
               sudo systemctl status ssh
 3. If not installed:
     - Install SSH server:
        
               sudo apt update && sudo apt install openssh-server
     - Enable and start the SSH server
       
               sudo systemctl enable ssh
               sudo systemctl start ssh
## Step 2: Find the Remote Machine's IP Address
### On the remote machine:
  1. Find the local IP:
     
                hostname -I
  #### Example output: 
   ![image](https://github.com/user-attachments/assets/435ae124-057e-4fa3-b572-cb56eef6a11d)
 2. If connecting over the internet, find the public IP: 
    
                curl ifconfig.me
## Step 3: Configure Firewall on Remote Machine
 
 1. Check if port 22 (default SSH port) is open:
    
                sudo ss -tlnp | grep ssh
 #### Output:
  ![image](https://github.com/user-attachments/assets/1c06f6b3-f39c-4925-88ee-2b976132902a)

 2. If a firewall is enabled, allow SSH connections:
    - Ubuntu (UFW):
      
                sudo ufw allow ssh
                sudo ufw enable
#### Output:
  ![image](https://github.com/user-attachments/assets/3b7544f5-b3e4-4cd5-91ae-c88cc8b1a614)
      
  - CentOS/RHEL (firewalld):
             
                sudo firewall-cmd --add-service=ssh --permanent
                sudo firewall-cmd --reload
## Step 4: Test SSH Connection

1. From the local machine, use the ssh command to connect:
     
                ssh username@remote_ip
   - Replace `username` with your `remote username` and `remote_ip` with the `remote machine's IP address`.
   #### Example:
                ssh -i ~/.ssh/id_rsa vignesh@192.168.1.6
   #### Output:
   ![image](https://github.com/user-attachments/assets/1bb7d514-125d-4c93-bfe3-debda6355479)
2. If it's the first time connecting, you'll see a message like:

                The authenticity of host 'remote_ip' can't be established.
   Type `yes` to continue.

3. Enter the `password` for the remote user when prompted.
      
## Step 5: (Optional) Set Up SSH Key-Based Authentication

1. Generate an SSH key pair on the local machine:
 
                 ssh-keygen -t rsa -b 4096
    Press `Enter` to save it in the default location `(~/.ssh/id_rsa)`.

2. Copy the public key to the remote machine:

                 ssh-copy-id username@remote_ip
3. Test the connection again; it should no longer prompt for a password:

                 ssh username@remote_ip


 
