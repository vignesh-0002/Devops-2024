
# 1. Script to install node-14


```
{
    
"builders": [
   {
     "type": "amazon-ebs",
     "region": "us-east-1",
     "instance_type": "t2.micro",
     "ami_name": "node-14-Ubuntu-Pro-20.04-{{timestamp}}",
     "source_ami_filter": {
                           "filters": {
                                 "virtualization-type": "hvm",
                                 "name": "ubuntu-pro-server*20.04-amd64*",
                                 "root-device-type": "ebs"
                              },
                           "owners": ["099720109477"],
                           "most_recent": true
                           },
    "ssh_username": "ubuntu"                       
   }
  ],



"provisioners": [
    {
      "type": "shell",
      "inline": [

       
        "sudo systemctl stop unattended-upgrades || echo 'Service not running'",
        "while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do echo 'Waiting for apt lock to be released...'; sleep 3; done",
        "sudo apt-get update -y",
        "sudo apt-get install npm -y",
        "sudo npm cache clean -f",
        "sudo npm install -g n",
        "sudo n 14",
        "node -v"
        
        
      ]
    }
  ]
  
  }
```
