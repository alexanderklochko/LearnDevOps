## Jenkins_task 
---------------------------------------------------------------------------------------
### General configurations
---------------------------------------------------------------------------------------
#### 1) Configuration jenkins agents 

+ Linux agent:
- create SSH connection (better to use Known hosts file Verification Strategy)
  - between controller and agent;
  - create labels and remote root directory;
+ Windows agent:
  - use Vagrant for install Windosws Server 2016 on Virtual Box 
    (ctrl+del switch to VM window);
  - install the same with Jenkins controller Java version in this case it's
    [OpenJDK"11.0.17" 2022-10-18 LTS](https://www.oracle.com/java/technologies/downloads/#java11-windows);
  - create jenkins user with administrative rights;
  - create windows agent in Jenkins controller (label, remote directory, 
    Launch method);
  - configure SSH connection between Jenkins controller and windows agent (jenkins user).

###### 1.2) Configuration Dynamic agent:

Configuration Dynamic agent possibly with this code-bclock in Jenkinsfile:

   ```js
    pipeline {
        agent { label 'master'}
        stages {
            stage('Build') {
                agent {
                    docker {
                      image 'maven:3.8.7-eclipse-temurin-11'
                      // Run the container on the node specified at the
                      // top-level of the Pipeline, in the same workspace,
                      reuseNode true
                    }
                }
                steps {
                    sh 'mvn -version'
                }
            }
        }
    }
```

Also you should install `Docker Commons Plugin` and `Docker Pipeline plugins`.

#### 2) Jenkins credentials

Through all this task were created credentials such as dockerhub, gitlab API,
SSH private key with username ans so on credentials in Manage Jenkins -> 
-> Manage Credentials section.
To work with credentials possible by `credentials binding plugin` and
 `credentials jenkins plugins`.
For given credentials use preinstalle plugin - `Matrix Authorization Strategy Plugin`.

#### 3) Access rights for groups and users

There were next steps: 
- Jenkins Dashbord -> Manage Jenkins -> Configure Global Security;
- Check "Enable security";
- Set "Jenkins own user database" as security realm;
- Check "Allow users to sign up";
- Choose "Matrix based security";
- Add your admin account in the matrix, check every box;
It's possible by installed `Matrix Authorization Strategy Plugin`.

### Jenkins multibranch

There were next steps:
- Install `GitLab Branch Source` and `Multibranch Scan Webhook Trigger` plugin.
  - Create or use existing credentials:
  - Gitlab personal access token (Gitlab API token not allowed, but it's almost
the same thing) and SSh private key;
- Configure GitLab Servers section in: Manage Jenkins -> Configure System;
- New item -> Multibranch pipeline:
    - Branch Sources:
        - Specify gitserver, owner, credentials and project;
        - Discover branches -> Strategy: All branched;
        - Discover merge requests from origin: Default (Merging th merge request with
          the current target branch version);
        - Property strategy: All branches have the same properties;
    - Scan GitLab Project Triggers (This section allows after installing 
    `Multibranch Scan Webhook Trigger` plugin).
    - Choose scan by webhook:
        - configure webhook in Gitlab: Gitlab project -> Settings -> Webhooks ->
          -> create webhook with the next payload: 
          <jenkinsserverURL>/multibranch-webhook-trigger/invoke?token=<token_name>
        - input <token_name> in Trigger token section;
- Create Jenkinsfile for every branch, for which will be created pipeline;
- Create bash script for checking commit message which must be compliance best
  practices, added sh stage to the Jenkins file;
- Add Docker lint stage to the Jenkins file and install 
[hadolint](https://tcoil.info/how-to-install-hadolint-on-linux/) on linux_node;
- Prohibit merge branch if pipeline was failed. Gitlab setting:
    - Multibranch pipeline -> settings -> general -> merge requests -> expands ->
      -> Merge checks -> Pipelines must succeed;

### Develop CI pipeline for [petclinic](https://gitlab.com/kTwice/petclinic) project

1. At first install 'GitLab Plugin' and create gilab connection in Manage Jenkins ->
-> Configure System -> Gitlab:
  - connection name;
  - Gitlab host URL;
  - Credentials: choose Gitlab API token (Create Gitlab Personal Access Tokens);
2. Jenkins integrations (dedicated integration for every project) and Gitlabwebhook 
(url for that you can find in such way: Jenkins Dashboard -> Job -> Configure -> Build Triggers section)
3. In job configuration for checking Jenkinsfile from Gitlab repository we need credentials, for this do:
  - login as jenkins user on Jenkins controller (create password, add to wheel/sudo group, add bin/bash shell), cause SSH keys must be in jenkins' home directory;
  - configure SSH connection between Jenkins controller and gitlab;
4. Install and Configure `Jenkins pipeline linter connector` in visual code.
5. Configuration linux agent (node). It's better for it use SSH host verificated stratagy:
  - create user jenkins on linux_node, create ~/jenkins_node as workspace, create ~/.ssh and authorized file in it with right access:
    - .ssh directory: 700 (drwx------);
    - public key (.pub file): 644 (-rw-r--r--);
    - private key 600: (-rw-------);
    - ~/.ssh/config 600: (-rw-------);
    - ~/.ssh/authorized_keys 600: (-rw-------);
  - install and configure [docker](https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/) on jenkins agent;
  - Jenkins works good with ed25519 ssh type connecion, therefore do:
    - ssh-keygen -t ed25519 -C "linux_agent";
    - cat linux_agent.pub >> authorized_keys.
  - Add credentional to Jenkins;
  - Login as jenkins user to jenkins_controller, add private_key to ssh_agent and do command `ssh <ip_jenkins_node>`;
  - Install git (then, in configuration job define Tool (path to git)), install docker, add exsting ssh key to /home/jenkins/.ssh
6. Extended [swap](https://aws.amazon.com/ru/premiumsupport/knowledge-center/ec2-memory-swap-file/) space to 2Gb and install [openJDK17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/amazon-linux-install.html).
7. Install and configure [Sonar](https://www.devopshint.com/how-to-install-sonarqube-on-amazon-linux-2/) with postgreSQL;
We can use t3.micro (free tier in EU-North region) for this if add swap 3GB space; Jenskins Plugin: `SonarQube Scanner for Jenkins`.
Integration sonar in CI:
   - Create SonarQube User Token at SonarQube Server: 
   - Administration > Configuration > Webhooks > Create
   - Manage Jenkins > Configure System > SonarQube servers
8. After instance was stoped, when it's started again, for successive implementing it's to pipeline you should:
  ###### for linux_node:
    - update 'known_host' file in /var/lib/jenkins/.ssh/. It's convinient simply to use command: `ssh <node_IP>` on jenkins_master server being loged as jenkins user;
    - update node configuration: Manage Jenkins -> Manage node and clouds ->
     linux_node: update host IP.
  ###### for sonar_node:
    - Manage Jenkins -> Configure System -> SonarQube installations -> Server URL
    (update IP);

### Develop CD pipeline for [petclinic](https://gitlab.com/kTwice/petclinic) project

1. Install `Active Choice` plugin - It's allow us to use any kind of Groovy script.
Create two parameter:
    - Choice (with deq and qa parameters, which are correponded to dev and qa jenkins agents );
    - Active choice for giving list of images from DockerHub (using scriptlet for it).
2. Install and configure two linux agents with installed docker in it.
3. Add healthcheck stage to Jenkinsfile (use bash script).
. Use `Email Extension Plugin` and `Mailer Plugin`, they are installed by default.
5. Setup SMTP in Jenkins (Manage Jenkins -> Configure System -> 
  ->Extended E-mail Notification) and add notification block to the Jenkinsfile.
  Use google App password for creating credentials.
