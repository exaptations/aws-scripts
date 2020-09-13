# aws-scripts

## AWS Serverless Application Model (SAM)

SAM install (requires: Homebrew --> Git) on AWS Linux:

    brew tap aws/tap
    brew install aws-sam-cli
    
Testing install: 

    sam --version

***

## Docker

Docker install on AWS Linux:

    sudo yum update -y
    sudo amazon-linux-extras install docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    
Testing install after exiting shell:

    docker ps

***

## Git

Git install on AWS Linux:

    sudo yum update -y
    sudo yum install git -y

Testing install:   

    git -v

***

## Gradle

### Gradle 6.6.1

Gradle install on AWS Linux:

    wget https://services.gradle.org/distributions/gradle-6.6.1-bin.zip 
    sudo mkdir /opt/gradle && sudo unzip gradle-6.6.1-bin.zip -d /opt/gradle
    echo 'GRADLE_HOME=/opt/gradle/gradle-6.6.1/bin' >>~/.bash_profile
    echo 'PATH=$GRADLE_HOME:$PATH' >>~/.bash_profile
    source ~/.bash_profile
 
 Testing install:
    
    gradle -v
    
***    
    
## Homebrew

Homebrew install on AWS Linux:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    
Testing install:

    brew --version

***

## HTTPie

HTTPie install (requires: PIP --> Python) on AWS Linux:

    pip install httpie
    
Testing install:

    http -v
    http PUT httpbin.org/put X-API-Token:123 name=John

***

## Java

### Java 8

Java 8 install on AWS Linux:

    sudo yum install java-1.8.0-openjdk -y
    sudo yum install java-1.8.0-openjdk-devel -y

Testing install:

    java -version

### Java 11

Java 11 install on AWS Linux:

    sudo amazon-linux-extras install java-openjdk11 -y

Testing install:

    alternatives --config java
    
### Switch Java Version

    sudo alternatives --config java
    java -version
    
***

## JQ

JQ install on AWS Linux:

    sudo yum install jq -y
    
Testing install:

    curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5' | jq '[.[] | {message: .commit.message, name: .commit.committer.name, parents: [.parents[].html_url]}]'

***

## Node

Node install on AWS Linux:

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    . ~/.nvm/nvm.sh
    nvm ls-remote
    nvm install node

Testing install:

    node --version
    npm --version

***

## Maven

### Maven 3.6.3

Maven install on AWS Linux:

    wget https://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
    sudo mkdir /opt/maven && sudo tar -zxf apache-maven-3.6.3-bin.tar.gz --directory /opt/maven/
    echo 'M2_HOME=/opt/maven/apache-maven-3.6.3' >>~/.bash_profile
    echo 'M2=$M2_HOME/bin' >>~/.bash_profile
    echo 'PATH=$M2:$PATH' >>~/.bash_profile
    source ~/.bash_profile
    
Testing install:

    mvn -version
    
***    

## Python PIP

Python and PIP install on AWS Linux:

    sudo yum install python37 -y
  
Testing install:

    python3 --version
    
PIP install on AWS Linux:

    curl -O https://bootstrap.pypa.io/get-pip.py
    python3 get-pip.py --user
    ls -a ~
    sudo vi .bash_profile
    Add the following to the profile: export PATH=LOCAL_PATH:$PATH
    source ~/.bash_profile

Testing install:

    pip --version

***

## Terraform

Terraform install on AWS Linux:

    sudo yum update -y
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform   
    
Testing install:    
    
    terraform -v
    
***    

## Useful References

- https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html
- https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-linux.html
- https://learn.hashicorp.com/tutorials/terraform/install-cli
