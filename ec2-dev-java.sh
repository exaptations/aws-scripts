#!/bin/bash
# Script to install a Java development stack
# Permission to copy and modify is granted under the foo license
# Last revised 12/09/2020

sudo yum update -y
# sudo yum install java-1.8.0-openjdk -y
sudo yum install java-1.8.0-openjdk-devel -y
sudo amazon-linux-extras install java-openjdk11 -y
wget https://services.gradle.org/distributions/gradle-6.6.1-bin.zip 
sudo mkdir /opt/gradle && sudo unzip gradle-6.6.1-bin.zip -d /opt/gradle
echo 'GRADLE_HOME=/opt/gradle/gradle-6.6.1/bin' >>~ec2-user/.bash_profile
echo 'PATH=$GRADLE_HOME:$PATH' >>~ec2-user/.bash_profile
# source ~/.bash_profile
wget https://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo mkdir /opt/maven && sudo tar -zxf apache-maven-3.6.3-bin.tar.gz --directory /opt/maven/
echo 'M2_HOME=/opt/maven/apache-maven-3.6.3' >>~ec2-user/.bash_profile
echo 'M2=$M2_HOME/bin' >>~ec2-user/.bash_profile
echo 'PATH=$M2:$PATH' >>~ec2-user/.bash_profile
# source ~/.bash_profile
