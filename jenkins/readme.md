## Jenkins_task 
-------------------------------------------------------------------------------------
### General configurations
-------------------------------------------------------------------------------------
#### 1) Configuration jenkins agents 

+ Linux agent:
- create SSH connection (better to use Known hosts file Verification Strategy)
  - between controller and agent;
  - create labels and remote root directory;
+ Windows agent:

###### 1.2) Configuration Dynamic agent:

Configuration Dynamic agent possibly with this code-clock in Jenkinsfile:

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
 -Install `GitLab Branch Source` plugin. Create or use existing credentials:
Gitlab personal access token (Gitlab API token not allowed, but it's almost
the same thing) and SSh private key;
- Configure GitLab Servers section in: Manage Jenkins -> Configure System;
- New item -> Multibranch pipeline -> Branch Sources -> gitlab_project:
  - Specify the gitlab user, credentials and choose multibranch project;
  - 
  -




















```sh
seq 254 | xargs printf "192.168.0.%s\n" | xargs -P0 -n1 ping -q -c1 | grep -B1 " 0% packet loss" | grep -B1 " 0% packet loss" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
```

![](./images/1.38.PNG)
___________________________________________________________________________________


rm -v !("file")
find /home/vagrant -amin +2 -amin -5 -exec rm -rv !("dir_link.sh"){} \;