#!/bin/bash

apt-get update
apt-get install git -y

apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get update

apt-get install ansible -y
apt-get install python-pip -y

pip install --upgrade boto boto3 awscli
pip install aws-ec2-assign-elastic-ip

# attach AWS EIP
aws-ec2-assign-elastic-ip --valid-ips ${aws_eip}

# Set Instance Identity URI
II_URI="http://169.254.169.254/latest/dynamic/instance-identity/document"

# Set region of NAT instance
REGION=`curl --retry 3 --retry-delay 0 --silent --fail $II_URI | grep region | awk -F\" '{print $4}'`

# Set AWS CLI default Region
export AWS_DEFAULT_REGION=$REGION

# Set Instance ID from metadata
INSTANCE_ID=$(curl --retry 3 --retry-delay 0 --silent --fail $II_URI | grep instanceId | awk -F\" '{print $4}')

# Turn off source / destination check
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --source-dest-check "{\"Value\": false}"

# get ssh private key for user that has read-only access to infrastructure repo
aws s3 cp s3://${s3_github_ssh_key} ~/.ssh/ || exit 1
chmod 600 ~/.ssh/id_rsa

# Disable strict host checking for git clone
echo -e "Host ${git_infrastructure_host}\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

# Add ansible vault password file
aws s3 cp s3://${s3_ansible_vault_file_key} /root/.vault.txt || exit 1

git clone ${git_infrastructure_repo} /opt/infrastructure || exit 1
cd /opt/infrastructure/ansible

# Setup EC2
ansible-galaxy install -r requirements/default.yml --roles-path ce-roles --force || exit 1
ansible-playbook -i inventories/localhost playbooks/default.yml --vault-password-file /root/.vault.txt || exit 1

# Install OpenVPN server
ansible-galaxy install -r requirements/openvpn.yml --roles-path ce-roles --force || exit 1
ansible-playbook -i inventories/localhost playbooks/openvpn.yml --vault-password-file /root/.vault.txt || exit 1

# Install Monitoring
ansible-galaxy install -r requirements/monitoring.yml --roles-path ce-roles --force || exit 1
ansible-playbook -i inventories/localhost playbooks/monitoring.yml --vault-password-file /root/.vault.txt || exit 1
