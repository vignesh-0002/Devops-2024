# **Jenkins Installation and Configuration Script**

## **Overview**
This Bash script automates the installation and configuration of Jenkins on a Debian-based system. It includes package updates, Java installation, Jenkins setup, disabling the setup wizard, plugin installation, and configuring the Jenkins URL.

---

## **Script Breakdown**

### **1. Update and Upgrade System Packages**
            ```bash
               sudo apt update && sudo apt upgrade -y

- Updates the system package list and upgrades all installed packages to the latest versions.

###  **2. Install Necessary Dependencies**

              sudo apt install -y fontconfig openjdk-17-jre wget
- Installs required packages:
   - fontconfig: Ensures font support for Jenkins.
   - openjdk-17-jre: Java runtime environment required for Jenkins.
   - wget: Tool for downloading files from the internet.

- 3. Verify Java Installation

              java -version
- Displays the installed Java version to confirm installation.



### **4. Add Jenkins Repository and Install Jenkins**
```
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
```
- Downloads and adds the Jenkins repository key.
```
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```
- Adds the Jenkins package repository.

                 sudo apt update
                 sudo apt install -y jenkins
- Updates the package list and installs Jenkins.

### **5. Enable and Start Jenkins**

                  sudo systemctl enable jenkins
                  sudo systemctl start jenkins
- Enables Jenkins to start on boot and starts the Jenkins service.


### **6. Extract Initial Admin Password**
```
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Jenkins initial password: $JENKINS_PASSWORD"
```
- Retrieves and displays the initial admin password required for Jenkins setup.

###  **7. Disable Setup Wizard**
```
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo bash -c 'cat <<EOF > /var/lib/jenkins/init.groovy.d/basic-security.groovy
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF'
```

- Creates an initialization script that:
   - Disables the setup wizard.
   - Creates an admin user with the credentials admin:admin123.
   - Configures Jenkins with full control for logged-in users.
```
sudo systemctl restart jenkins
Restarts Jenkins to apply changes.
```
### **8. Install Required Jenkins Plugins**

```
url=http://localhost:8080
user=admin
password=admin123
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})
```

- Sets Jenkins URL and credentials.
- Fetches the security crumb required for Jenkins API requests.
```
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"
```
- Installs essential plugins for Jenkins pipeline and project management.


### **9. Configure Jenkins URL**
```
JENKINS_URL="http://localhost:8080/"
JENKINS_CONFIG_XML="/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml"

sudo bash -c "cat <<EOF > $JENKINS_CONFIG_XML
<?xml version='1.1' encoding='UTF-8'?>
<jenkins.model.JenkinsLocationConfiguration>
  <adminAddress>vigneshs00@outlook.com</adminAddress>
  <jenkinsUrl>$JENKINS_URL</jenkinsUrl>
</jenkins.model.JenkinsLocationConfiguration>
EOF"
```
- Sets the Jenkins instance's configuration URL and admin contact.
```
sudo systemctl restart jenkins
```
- Restarts Jenkins to apply the configuration changes.


- Final Output
  - The script concludes with the following message:
```
echo "Jenkins installation, plugin setup, and URL configuration complete!"
echo "Login with Username: admin and Password: admin123"
```
- Confirms the successful installation and configuration of Jenkins.
- Displays the default login credentials for accessing Jenkins.
