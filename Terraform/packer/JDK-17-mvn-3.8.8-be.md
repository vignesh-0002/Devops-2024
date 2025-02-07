# Backend-script to install jdk and mvn 
```
{
    
    "builders": [
       {
         "type": "amazon-ebs",
         "region": "us-east-1",
         "instance_type": "t2.micro",
         "ami_name": "be-jdk-mvn-instance-Ubuntu-Pro-20.04-{{timestamp}}",
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
   
            
            "while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do echo 'Waiting for apt lock to be released...'; sleep 3; done",
            "sudo apt update -y",
            "sudo apt install openjdk-17-jdk openjdk-17-jre -y",
            "wget https://downloads.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz",
            "sudo tar xf apache-maven-3.8.8-bin.tar.gz -C /opt",
            "touch ~/.bashrc",
            "echo 'export M2_HOME=/opt/apache-maven-3.8.8' | sudo tee -a ~/.bashrc",
            "echo 'export MAVEN_HOME=/opt/apache-maven-3.8.8' | sudo tee -a ~/.bashrc",
            "echo 'export PATH=$M2_HOME/bin:$PATH' | sudo tee -a ~/.bashrc",
            "export PATH=$PATH:/opt/apache-maven-3.8.8/bin",
            "mvn -v"






        ]
      }
    ]

}
```
