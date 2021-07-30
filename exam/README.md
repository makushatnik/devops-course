# The Exam

## Technologies I used:
1. CI/CD (Jenkins)
2. Python
3. Flask
4. Go
5. Gin
6. Java
7. Spring
8. Docker
9. SonarQube
10. Rsyslog
11. Git

## Preparing for running

### Install Java

### Install Docker

### Install Jenkins

## Installing Jobs
Installing job going manually from the `/jobs` directory.  
You need to get access to your Linux server by **SSH** or something, upload xml files from the mentioned above directory into:  
`/var/lib/jenkins/jobs`

## Java Containers
1st image for Java was - 441Mb.

## Using

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

### Further development
* If I had enough time, I would replace Github by Gitlab.
* If I had enough time, I would make Docker containers management - Kubernetes or Swarm.