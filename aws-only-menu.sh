AL2_AMI=ami-0dc2d3e4c0f9ebd18
UBUNTU_1804_LTS_AMI=ami-0747bdcabd34c712a

aws_instance_type () { 
local PS3='Please select instance type: '
local options=("t2.micro" "t2.small" "t2.medium" "t3.micro" "t3.small" "t3.medium")
local opt
select opt in "${options[@]}"
do
case $opt in
"t2.micro")
instance_type="t2.micro"
return
;;
"t2.small")
instance_type="t2.small"
return
;;
"t2.medium")
instance_type="t2.medium"
return
;;
"t3.micro")
instance_type="t3.micro"
return
;;
"t3.small")
instance_type="t3.small"
return
;;
"t3.medium")
instance_type="t3.medium"
return
;;		  
*) echo "invalid option $REPLY";;
esac
done
}

aws_cli_key_pair_install () { 
cat << EOF_PUB_KEY >> ~/public_key.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK6NZGlkMggaLOFEfbyGB7Doz1tOmVN0waLvqNAwUoTf0BUaa/V022e7G2XemUTVV/3mTK4kRKPWJIsfJWPKmJ/c+WLfXns3EGfoadLWP/moKaLdeMWZdvDyDWSH+47h/2ZnUyMkQfM18mdnYcL7jEUNc3fl2C0q7o0MRWDsKiqJVNfdEGIHtIJCvAxe+8E3b67sOs+nSLp5Od/DFS51G7sS+0tYm8iNVgG60kMepQkzLhPJqmD3VbyzNUg/9zkLNwjddiajedlBkj3eBm4AyP/TMpKlc3a15P/W9RtGPCy/Rrb6z/R3UkPUJXJPooMJscveqGieulQUZu+67IX+f9
EOF_PUB_KEY

aws ec2 import-key-pair --key-name "MyKeyPair" --public-key-material fileb://~/public_key.pub 

rm ~/public_key.pub
}

aws_cli_install () { 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
mv awscliv2.zip /tmp/
unzip /tmp/awscliv2.zip 
./tmp/aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
}

aws_sam_install () { 
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
mv aws-sam-cli-linux-x86_64.zip /tmp/
unzip /tmp/aws-sam-cli-linux-x86_64.zip -d sam-installation
./tmp/sam-installation/install
}

aws_cli_create_common_sg () { 
DEFAULTVPCID="$(aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text)"
aws ec2 create-security-group --group-name common-sg --description "Common Security Group" --vpc-id $DEFAULTVPCID
SG_COMMON="$(aws ec2 describe-security-groups --filters Name=group-name,Values=common-sg --query "SecurityGroups[*].{ID:GroupId}" --output text)"

aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 3389 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 8000 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 9000 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 8080 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_COMMON --protocol tcp --port 3000 --cidr 0.0.0.0/0
}

aws_cli_create_camunda_run_instance () { 
cat << EOF_SCRIPT >> ~/user-data-camunda.txt
#!/bin/bash -ex

cat << EOF >> ~/install-mymenu.sh
#!/bin/bash
openssl enc -md sha256 -aes-256-cbc -a -d -in /tmp/mymenu.sh.enc -out /tmp/mymenu.sh
chmod +x /tmp/mymenu.sh
sudo mv /tmp/mymenu.sh /bin/
EOF

chmod +x ~/install-mymenu.sh
mv ~/install-mymenu.sh /bin/

yum update -y
pip3 install gdown
gdown --id  1JyFOWkyxwE1E3aTQHTKjLAogIGd47oQm -O /tmp/mymenu.sh.enc
gdown --id  1755d2GBtkK457ZwT4Ii_CVPtTm9X_mX3 -O /tmp/out.zip
amazon-linux-extras install -y java-openjdk11
unzip /tmp/out.zip -d /opt/
sed -i 's/BASEDIR=\\\$(dirname \"\\\$0\")/BASEDIR=\\\$(dirname -- \"\\\$0\")/g' /opt/camunda-bpm-run-ee-7.15.6-ee/start.sh
chmod +x /opt/camunda-bpm-run-ee-7.15.6-ee/start.sh
chown ec2-user:ec2-user -R /opt/camunda-bpm-run-ee-7.15.6-ee/
cd /opt/camunda-bpm-run-ee-7.15.6-ee/ && nohup ./start.sh &
EOF_SCRIPT

#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id ami-0dc2d3e4c0f9ebd18 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/xvda\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
--user-data file://user-data-camunda.txt > /tmp/$(date +%s)_instance_create.json

rm ~/user-data-camunda.txt
}

aws_cli_create_camunda_tomcat_instance () { 
cat << EOF_SCRIPT >> ~/user-data-camunda.txt
#!/bin/bash -ex

cat << EOF >> ~/install-mymenu.sh
#!/bin/bash
openssl enc -md sha256 -aes-256-cbc -a -d -in /tmp/mymenu.sh.enc -out /tmp/mymenu.sh
chmod +x /tmp/mymenu.sh
sudo mv /tmp/mymenu.sh /bin/
EOF

chmod +x ~/install-mymenu.sh
mv ~/install-mymenu.sh /bin/

yum update -y
pip3 install gdown
gdown --id  1JyFOWkyxwE1E3aTQHTKjLAogIGd47oQm -O /tmp/mymenu.sh.enc
gdown --id  1X0vSW4RnBhtBK7BvvXi6MxNgw18XYYTg -O /tmp/out.zip
amazon-linux-extras install -y java-openjdk11
unzip /tmp/out.zip -d /opt/
chmod +x /opt/camunda-bpm-ee-tomcat-7.15.6-ee/*.sh
chmod +x /opt/camunda-bpm-ee-tomcat-7.15.6-ee/server/apache-tomcat-9.0.52/bin/*.sh
chown ec2-user:ec2-user -R /opt/camunda-bpm-ee-tomcat-7.15.6-ee/
cd /opt/camunda-bpm-ee-tomcat-7.15.6-ee/ && nohup ./start-camunda.sh &
EOF_SCRIPT

#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id ami-0dc2d3e4c0f9ebd18 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/xvda\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
--user-data file://user-data-camunda.txt > /tmp/$(date +%s)_instance_create.json

rm ~/user-data-camunda.txt
}

aws_cli_create_httpd_instance () { 
cat << EOF >> ~/user-data-httpd.txt
#!/bin/bash -ex
yum update -y			# update packager, just in case the image is outdate
yum install -y httpd    # install apache httpd
service httpd start     # start apache httpd
chkconfig httpd on      # start apache httpd on every start and reboot
chkconfig --list httpd	# log the status of httpd config
EOF

#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id ami-0dc2d3e4c0f9ebd18 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/xvda\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
--user-data file://user-data-httpd.txt > /tmp/$(date +%s)_instance_create.json

rm ~/user-data-httpd.txt
}

aws_cli_create_dev_instance_ubuntu () { 
cat << EOF_SCRIPT >> ~/user-data-bootstrap-menu.txt
#!/bin/bash
apt-get update -y
apt-get upgrade -y
sud

cat << EOF >> ~/gdfg.sh
#!/bin/bash
fileid="\\\$1"
filename="\\\$2"
curl -c /tmp/cookie -s -L "https://drive.google.com/uc?export=download&id=\\\${fileid}" > /dev/null
curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=\\\`awk '/download/ {print \\\$NF}' /tmp/cookie\\\`&id=\\\${fileid}" -o \\\${filename}
EOF

chmod +x ~/gdfg.sh
mv ~/gdfg.sh /bin/

gdfg.sh 1JyFOWkyxwE1E3aTQHTKjLAogIGd47oQm mymenu.sh.enc
chmod +x mymenu.sh
mv mymenu.sh.enc /tmp/

cat << EOF >> ~/install-mymenu.sh
#!/bin/bash
openssl enc -md sha256 -aes-256-cbc -a -d -in /tmp/mymenu.sh.enc -out /tmp/mymenu.sh
chmod +x /tmp/mymenu.sh
sudo mv /tmp/mymenu.sh /bin/
EOF

chmod +x ~/install-mymenu.sh
mv ~/install-mymenu.sh /bin/
EOF_SCRIPT

#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id $1 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/xvda\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
--user-data file://user-data-bootstrap-menu.txt > /tmp/$(date +%s)_instance_create.json

rm ~/user-data-bootstrap-menu.txt
}

aws_cli_create_dev_instance_al2 () { 
cat << EOF_SCRIPT >> ~/user-data-bootstrap-menu.txt
#!/bin/bash
yum update -y

cat << EOF >> ~/gdfg.sh
#!/bin/bash
fileid="\\\$1"
filename="\\\$2"
curl -c /tmp/cookie -s -L "https://drive.google.com/uc?export=download&id=\\\${fileid}" > /dev/null
curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=\\\`awk '/download/ {print \\\$NF}' /tmp/cookie\\\`&id=\\\${fileid}" -o \\\${filename}
EOF

chmod +x ~/gdfg.sh
mv ~/gdfg.sh /bin/

gdfg.sh 1JyFOWkyxwE1E3aTQHTKjLAogIGd47oQm mymenu.sh.enc
chmod +x mymenu.sh
mv mymenu.sh.enc /tmp/

cat << EOF >> ~/install-mymenu.sh
#!/bin/bash
openssl enc -md sha256 -aes-256-cbc -a -d -in /tmp/mymenu.sh.enc -out /tmp/mymenu.sh
chmod +x /tmp/mymenu.sh
sudo mv /tmp/mymenu.sh /bin/
EOF

chmod +x ~/install-mymenu.sh
mv ~/install-mymenu.sh /bin/
EOF_SCRIPT

#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id $1 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/xvda\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
--user-data file://user-data-bootstrap-menu.txt > /tmp/$(date +%s)_instance_create.json

rm ~/user-data-bootstrap-menu.txt
}

aws_cli_create_ms-windows-server-2019_instance () { 
#Select instance type
aws_instance_type

aws ec2 run-instances \
--image-id ami-02cc00a60f7d8adb7 \
--count 1 --instance-type $instance_type \
--security-groups common-sg \
--key-name MyKeyPair \
--block-device-mapping "[ { \"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"VolumeSize\": 100, \"VolumeType\": \"gp2\" } } ]" \
> /tmp/$(date +%s)_instance_create.json
}

aws_code-server_install () { 
echo "Installing Code Server"
curl -fsSL https://code-server.dev/install.sh | sh
}


aws_cli_submenu () { 
local aws_cli_options=("Install AWS CLI V2" "Install AWS SAM" "Install Code Server" "Install Key Pair" "Create Common Security Group" "Create AL2 Camunda Run Instance" "Create AL2 Camunda Tomcat Instance" "Create AL2 Httpd Instance" "Create AL2 Dev Instance" "Create Ubuntu Dev Instance" "Create Microsoft Windows Server 2019 Instance" "See AWS CLI Submenu Options" )
#local aws_cli_options=("Sub menu item 1" "Sub menu item 2" "Sub menu quit" "Print Options")
local prompt="Please enter AWS CLI option - To see options hit "
local prompt+="${#aws_cli_options[@]} - Ctrl + C to quit: "  
echo ''
local PS3=$prompt
local opt
select opt in "${aws_cli_options[@]}"
do
case $opt in
"Install AWS CLI V2")
aws_cli_install
;;
"Install AWS SAM")
aws_sam_install
;;
"Install Code Server")
aws_code-server_install
;;
"Install Key Pair")
aws_cli_key_pair_install
;;
"Create Common Security Group")
aws_cli_create_common_sg
;;
"Create AL2 Camunda Run Instance")
aws_cli_create_camunda_run_instance
;;
"Create AL2 Camunda Tomcat Instance")
aws_cli_create_camunda_tomcat_instance
;;
"Create AL2 Httpd Instance")
aws_cli_create_httpd_instance
;;
"Create AL2 Dev Instance")
aws_cli_create_dev_instance_al2 $AL2_AMI
;;
"Create Ubuntu Dev Instance")
aws_cli_create_dev_instance_al2 $UBUNTU_1804_LTS_AMI
;;
"Create Microsoft Windows Server 2019 Instance")
aws_cli_create_ms-windows-server-2019_instance
;;
"See AWS CLI Submenu Options")
local PS3=""
echo ''
echo asdf | select foo in "${aws_cli_options[@]}"; do break; done
local prompt="Please enter AWS CLI submenu option - To see submenu options hit "
local prompt+="${#aws_cli_options[@]} - Ctrl + C to quit: "
local PS3=$prompt
;;
*) echo "invalid option $REPLY";;
esac
done
}

aws_cli_submenu