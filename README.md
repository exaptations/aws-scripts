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
    sudo yum install git

Testing install:   

    git -v

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
