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
