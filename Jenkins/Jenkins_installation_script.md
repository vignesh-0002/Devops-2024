# Bash Script to Set Up Jenkins with Custom Configuration and Plugins

This script automates the process of setting up Jenkins on an EC2 instance, including the installation of necessary packages, creating an admin user, disabling the setup wizard, configuring Jenkins URL, and installing required plugins.


### 1. Shebang

                 #!/bin/bash

- This line tells the system to use the bash shell to interpret the script.

### 2. Define a Function to Wait for Jenkins to be Ready
```
function wait_for_jenkins() {
    local url=$1
    echo "Waiting for Jenkins to be ready at $url..."
    until curl -sL -w "%{http_code}" "$url" -o /dev/null | grep -q "200"; do
        sleep 5
    done
    echo "Jenkins is ready!"
}
```
- The wait_for_jenkins function accepts a URL as an argument.
- It continuously sends a curl request to the specified URL and checks for a successful HTTP response code (200).
- The script will retry every 5 seconds until Jenkins is available.

 ### 3. Get the Public IP Address of the EC2 Instance
```
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")" -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Public IP: $PUBLIC_IP"
```
- This block retrieves the public IP address of the EC2 instance by querying the EC2 metadata service.
- The curl command makes a request to get the public IPv4 address.

### 4. Update System Packages
```
sudo apt update && sudo apt upgrade -y
```
- Updates the package list and upgrades installed packages on the system to their latest versions.
### 5. Install Necessary Dependencies
```
sudo apt install -y fontconfig openjdk-17-jre wget
```
- Installs the necessary dependencies, such as font configuration, `Java (OpenJDK 17)`, and wget for downloading files.
### 6. Verify Java Installation

          java -version
- Verifies the installation of Java by printing the Java version installed on the system.
### 7. Add Jenkins Repository Key
```
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
```
- Downloads and saves the Jenkins repository key to `/usr/share/keyrings/jenkins-keyring.asc`.


### 8. Add Jenkins Repository to APT Sources List
```
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```
- Adds the Jenkins repository to the system’s APT sources list, allowing the installation of Jenkins via APT.
### 9. Update Package List Again After Adding Jenkins Repository
```
sudo apt update
```
- Updates the system's package list after adding the Jenkins repository.

### 10. Install Jenkins
```
sudo apt install -y jenkins
```
- Installs Jenkins from the newly added repository.
### 11. Enable and Start Jenkins Service
```
sudo systemctl enable jenkins
sudo systemctl start jenkins
```
- Enables the Jenkins service to start on boot and starts Jenkins immediately.
### 12. Extract Jenkins Initial Admin Password
```
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Jenkins initial password: $JENKINS_PASSWORD"
```

- Retrieves the initial Jenkins admin password from the file `/var/lib/jenkins/secrets/initialAdminPassword` and prints it.

### 13. Download Jenkins CLI
```
wget http://$PUBLIC_IP:8080/jnlpJars/jenkins-cli.jar -P ~
```
- Downloads the Jenkins CLI (jenkins-cli.jar) to the home directory.
### 14. Create Jenkins Admin User Using Jenkins CLI
```
USERNAME="admin"
PASSWORD="admin123"
FULLNAME="Admin User"
EMAIL="vigneshs00@outlook.com"

echo "Creating Jenkins admin user..."
echo "jenkins.model.Jenkins.instance.securityRealm.createAccount('$USERNAME', '$PASSWORD')" | \
    java -jar ~/jenkins-cli.jar -s http://$PUBLIC_IP:8080/ -auth admin:$JENKINS_PASSWORD groovy =
```
- Sets the username, password, full name, and email for the Jenkins admin user.
- Uses the Jenkins CLI to create a new admin account by running a Groovy script.
### 15. Disable Jenkins Setup Wizard
```
echo "Disabling Jenkins setup wizard..."
sudo bash -c 'echo "jenkins.install.runSetupWizard=false" >> /etc/default/jenkins'
sudo systemctl restart jenkins
```
- Disables the Jenkins setup wizard by modifying the `/etc/default/jenkins` file and setting - - - `jenkins.install.runSetupWizard=false`.
- Restarts Jenkins to apply the change.
### 16. Configure Jenkins URL:
```
JENKINS_URL="http://$PUBLIC_IP:8080"
echo "Configuring Jenkins URL to $JENKINS_URL..."
JENKINS_CONFIG_XML="/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml"

sudo bash -c "cat <<EOF > $JENKINS_CONFIG_XML
<?xml version='1.1' encoding='UTF-8'?>
<jenkins.model.JenkinsLocationConfiguration>
  <adminAddress>vigneshs00@outlook.com</adminAddress>
  <jenkinsUrl>$JENKINS_URL</jenkinsUrl>
</jenkins.model.JenkinsLocationConfiguration>
EOF"
```
- Configures the Jenkins URL to the public IP address of the EC2 instance.
- Modifies the jenkins.model.JenkinsLocationConfiguration.xml file to set the Jenkins URL and admin email.
### 17. Restart Jenkins to Apply Configuration Changes
```
sudo systemctl restart jenkins
```
- Restarts the Jenkins service to apply the URL configuration changes.

18. Install Jenkins Plugins via Jenkins API
```
url="http://$PUBLIC_IP:8080"
user="admin"
password="admin123"

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

echo "Installing Jenkins plugins..."
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{
    'dynamicLoad':true,
    'plugins':[ 'cloudbees-folder', 'antisamy-markup-formatter', 'build-timeout', 'credentials-binding',
        'timestamper', 'ws-cleanup', 'ant', 'gradle', 'workflow-aggregator', 'github-branch-source',
        'pipeline-github-lib', 'pipeline-stage-view', 'git', 'ssh-slaves', 'matrix-auth', 'pam-auth',
        'ldap', 'email-ext', 'mailer'
    ],
    'Jenkins-Crumb':'$only_crumb'
  }"
  ```
- The script retrieves a Jenkins "crumb" for CSRF protection and sends a POST request to install a list of essential Jenkins plugins.
- The plugins include useful tools for building, testing, and integrating with other services (e.g., GitHub, email notifications).

### 19. Final Message
```
echo "Jenkins setup and plugin installation complete!"
```
- Prints a message indicating the completion of Jenkins setup and plugin installation.
  
