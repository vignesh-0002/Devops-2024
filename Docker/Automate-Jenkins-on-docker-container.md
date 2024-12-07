# Automating Jenkins installation inside docker container:
- Example Directory Structure for Jenkins Docker Setup
```
├── Dockerfile.jenkins
├── plugins.txt
├── init.groovy.d/
│   └── Basic-configuration.groovy
│   └──  configure-url.groovy
└── users/
    └── admin/
        └── config.xml
```

# Dockerfile.jenkins
```
FROM jenkins/jenkins:lts

# Disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Install plugins via Jenkins CLI
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt

# Copy custom Groovy scripts for initial configuration
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Preload Jenkins configuration (admin user and other settings)
COPY users/admin/config.xml /usr/share/jenkins/ref/users/admin/config.xml
```
# Jenkins Dockerfile Explanation
- This document provides an explanation of each step in the Dockerfile for setting up a 
Jenkins instance with pre-configured plugins, Groovy scripts, and user settings.
## Dockerfile Explanation
### Base Image:
```
FROM jenkins/jenkins:lts
```
  - The Dockerfile starts with the official Jenkins Long-Term Support (LTS) image, which provides a stable,
     production-ready version of Jenkins.
### Disable Setup Wizard:
```
# Disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
```
  - Sets an environment variable `(JAVA_OPTS)` to disable the Jenkins setup wizard. This ensures Jenkins starts directly
    into the main interface without the need for initial configuration, which is helpful for automation.
### Install Plugins:
```
# Install plugins via Jenkins CLI
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt
```
  - `COPY plugins.txt`: This command copies the `plugins.txt` file, which contains a list of Jenkins plugins
    and their versions, into the container's appropriate directory.
  - `jenkins-plugin-cli`: Uses Jenkins's plugin command-line interface to install the plugins listed in the `plugins.txt`
    file.This allows the Jenkins instance to have the necessary plugins pre-installed.

### Example of plugins.txt:
```
workflow-aggregator:2.5
git:5.6.0
docker-workflow:1.26
sonar:2.15
docker-commons:1.18
blueocean:1.27.16
```


### Custom Initialization Scripts:

```
# Copy custom Groovy scripts for initial configuration
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

```
- This command copies any Groovy scripts located in the `init.groovy.d/` directory on the host machine into Jenkins's 
initialization directory inside the container. 
- These scripts are executed the first time Jenkins starts, enabling further customization like setting
  URLs, users, or credentials.

### Example of a Groovy script (init.groovy.d/configure-url.groovy):

```
import jenkins.model.*

def env = System.getenv()
def hostIP = env['HOST_IP'] ?: '127.0.0.1' // Default to localhost if not provided

def jenkinsUrl = "http://${hostIP}:8080"
def jenkinsLocationConfig = JenkinsLocationConfiguration.get()
jenkinsLocationConfig.setUrl(jenkinsUrl)
jenkinsLocationConfig.save()

println "Configured Jenkins URL: ${jenkinsUrl}"
```
### Example of a Groovy script (init.groovy.d/basic-configuration.groovy)

```
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

// Create admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

// Set authorization strategy
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Save configuration
instance.save()
```

### Preload Jenkins Configuration
```
# Preload Jenkins configuration (admin user and other settings)
COPY users/admin/config.xml /usr/share/jenkins/ref/users/admin/config.xml

```
- This command copies a predefined configuration file for the admin user `(including username, password, and permissions)`
  into the Jenkins container.
- This ensures that Jenkins starts with the admin user and other predefined settings in place.

  ### Example of config.xml:
```
<?xml version='1.1' encoding='UTF-8'?>
<user>
  <fullName>Admin</fullName>
  <properties>
    <hudson.security.HudsonPrivateSecurityRealm_-Details>
      <passwordHash>#jbcrypt:$2a$10$rd6n0cu6Sq2MvKLW09OEieo1beLpHjXIx1T7iBFogxyWWa3UAYLGW</passwordHash>
    </hudson.security.HudsonPrivateSecurityRealm_-Details>
  </properties>
</user>
```
# Summary of Dockerfile Functionality
## This Dockerfile:

- 1. Uses the Jenkins LTS image as the base.
- 2. Disables the setup wizard for automatic startup.
- 3. Installs specified plugins via the Jenkins Plugin CLI from the plugins.txt file.
- 4. Copies and runs custom Groovy scripts to configure Jenkins during initialization.
- 5. Preloads the admin user configuration file to ensure specific user settings upon startup.
