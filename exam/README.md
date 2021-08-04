# The Exam

## Technologies I used:
1. CI/CD (Jenkins)
2. Python
3. Flask
4. Go
5. Gin
6. Java
7. Spring
8. Docker/Docker Compose
9. SonarQube
10. Git

## Preparing for running

### Install Java
Install package:
    sudo apt install openjdk-8-jdk
    or
    sudo apt install openjdk-8-jre
Then add in the end of the .bashrc file:
    export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_221/
    export PATH=$PATH:$JAVA_HOME/bin

### Install PostgreSQL
    sudo su postgres
    sudo apt install postgresql postgresql-contrib
    createuser sonar
    psql
    ALTER USER sonar WITH ENCRYPTED password '<YOUR PASSWORD>';
    CREATE DATABASE sonar OWNER sonar;
    \q

### System settings
    sudo adduser --system --no-create-home --group --disabled-login sonarqube
    sudo mkdir /data/sonarqube
    sudo mkdir /data/sonarscanner
	sudo chown -R sonarqube:sonarqube /data/sonarqube
	sudo chown -R sonarqube:sonarqube /data/sonarscanner

### Install Docker
    sudo apt install linux-image-extra-$(uname -r) linux-image-extra-virtual
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update && apt-cache policy docker-ce
    sudo apt install -y docker-ce
    sudo usermod -aG docker $(whoami)

### Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
	
### SonarQube
Run SonarQube:
`docker-compose -f sonarqube.yml up`
and add 3 projects there, get 3 access tokens.

### Install Gitlab
Go to another server on CentOS Linux and install Gitlab.  
Preparing:

    sudo yum install openssh-server
    sudo yum install postfix
    sudo systemctl enable postfix
    sudo systemctl start postfix
    sudo systemctl stop firewalld
    sudo setenforce 0

Install Ruby on Rails:

    sudo yum install -y curl gpg gcc gcc-c++ make patch autoconf automake bison libffi-devel libtool patch readline-devel sqlite-devel zlib-devel openssl-devel
    sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install 2.7.2
    rvm use 2.7.2 --default
    echo "gem: --no-document" > ~/.gemrc
    gem install bundler
    gem install rails

Install Gitlab:

    curl -O https://downloads-packages.s3.amazonaws.com/centos-7.0.1406/gitlab-7.4.3_omnibus.5.1.0.ci-1.el7.x86_64.rpm
    sudo rpm -ivh gitlab-7.4.3_omnibus.5.1.0.ci-1.el7.x86_64.rpm
    (hostname --fqdn)
    sudo nano /opt/gitlab/embedded/cookbooks/gitlab/libraries/gitlab.rb
    sudo gitlab-ctl reconfigure
    sudo gitlab-ctl restart
Get password from:  
`/etc/gitlab/initial_root_password`  
and paste it in the web-interface, change root password.  
Create new users, every user need to check email for sign in link and change password:  
`mail -u <user>`  
Generate SSH:  
`ssh-keygen -t rsa -C "user1@centos7.local"`  
and add it in web-interface.
`git remote add devops-course git@centos7.local:wizard/devops-course.git`

### Install Jenkins
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
      /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins
    sudo usermod -aG docker jenkins
    su - jenkins
    ssh-keygen
Then paste `~/.ssh/id_rsa` into Jenkins and `~/.ssh/id_rsa.pub` into Github/Gitlab settings.
Plugins needed:
1. Git  
2. Pipeline  
3. Docker  
4. Docker Pipeline
5. Pyenv  
6. Gitlab  
7. Oracle JDK Installer  
Add a Webhook token and settings in Jenkins and paste Url, token in Gitlab.

## Installing Jobs
Installing job going manually from the `/jobs` directory.  
You need to get access to your Linux server by **SSH** or something, upload xml files from the mentioned above directory into:  
`/var/lib/jenkins/jobs`

## Java Containers
1st image for Java weighs - 441Mb. That image is considering for good JVM memory management using start container command like that:  
`docker run -it --rm --name webserver -m 2Gb spring_hello exec java -Xmx1024m -cp . -jar /deployments/hello-0.0.1.jar`
2nd image for Java weighs - 168Mb. It's from Java 11 and Alpine, start container command:  
`docker run -d -p 8083:8080 -t spring_hello:0.0.1`

## Using
Jenkins build jobs save images in the [official docker registry](http://hub.docker.com).

### Continuous Integration
This is the part about code linting, build, test and getting results back into Git service.  
As a Git service used Github right now.  
It's useful at the moment of Pull Request/Code review. It doesn't lead to deploy actually.  
You just need to push some code on the Git service to start a job.

### Continuous Delivery
This is the part about deploy.  
Checking for changes in the ***dev*** branch going every 5 minutes.  
If new changes appeared, Jenkins will start the job. It has linting, build, test, deploy stages.
You need to merge Pull Request into ***dev*** branch to get a job started.

### Troubleshooting
I had encountered with some troubles:  
1. No way to install Golang later version than 1.10.4 on **Ubuntu 18.04**. Which makes impossible to run Gin there.  
I avoided that problem using CentOS instead. Docker **golang:latest** image is better option.  
2. There're some issues with installing SonarQube locally.  
I solved these issues by installing Docker Compose and using SonarQube in a Docker image.  

### Further development
* If I had enough time, I would replace Github by Gitlab and replace Docker images there.  
* If I had enough time, I would make Docker containers management - Kubernetes or Swarm.