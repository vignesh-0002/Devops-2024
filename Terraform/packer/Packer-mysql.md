# packer script to install mysql-EMS-ops

```
{
    
    "builders": [
       {
         "type": "amazon-ebs",
         "region": "us-east-1",
         "instance_type": "t2.micro",
         "ami_name": "Mysql-instance-Ubuntu-Pro-20.04-{{timestamp}}",
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
        "sudo rm -rf /var/lib/apt/lists/*", 
  "sudo apt-get clean",
  "sudo apt-get update -o Acquire::CompressionTypes::Order::=gz",
  "sudo mv /usr/lib/cnf-update-db /usr/lib/cnf-update-db.bak || echo 'No cnf-update-db found to move'",
  "while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do echo 'Waiting for apt lock to be released...'; sleep 3; done",
  "sudo apt update -y",
  "sudo DEBIAN_FRONTEND=noninteractive apt install mysql-server -y",

  "sudo systemctl start mysql",
  "sudo mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';\"",
  "sudo mysql -e \"FLUSH PRIVILEGES;\"",
  
  "sudo mysql -u root -ppassword -e \"CREATE USER 'username'@'%' IDENTIFIED BY 'password';\"",
  "sudo mysql -u root -ppassword -e \"GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION;\"",
  "sudo mysql -u root -ppassword -e \"FLUSH PRIVILEGES;\"",
  "sudo mysql -u root -ppassword -e \"CREATE DATABASE databasename;\""
        ]
      }
    ]

  
}




```
