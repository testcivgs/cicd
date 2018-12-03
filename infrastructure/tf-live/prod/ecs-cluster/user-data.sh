#!/bin/bash

# Default PATH=/sbin:/usr/sbin:/bin:/usr/bin
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

yum update -y
yum install -y aws-cli aws-cfn-bootstrap jq git

easy_install pip
/usr/local/bin/pip install --upgrade awscli boto boto3 ansible

# get ssh private key for user that has read-only access to infrastructure repo
aws s3 cp s3://${s3_github_ssh_key} ~/.ssh/ || exit 1
chmod 600 ~/.ssh/id_rsa

# Disable strict host checking for git clone
echo -e "Host ${git_infrastructure_host}\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

git clone ${git_infrastructure_repo} /opt/infrastructure || exit 1
cd /opt/infrastructure/ansible

# Install aws-ec2-ssh
/usr/local/bin/ansible-galaxy install -r requirements/default.yml --roles-path roles --force || exit 1
/usr/local/bin/ansible-playbook -i inventories/localhost playbooks/default.yml || exit 1

# Write the cluster configuration variable to the ecs.config file
# (add any other configuration variables here also)
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_cluster}
ECS_ENABLE_TASK_IAM_ROLE=true
# Expouse various container metadata within ECS task containers
ECS_ENABLE_CONTAINER_METADATA=true
# tell logspout to ignore ecs-agent container by setting LOGSPOUT environment variable
LOGSPOUT=ignore
EOF

start ecs

until curl -s http://localhost:51678/v1/metadata; do
    sleep 1
done

# Grab the container instance ARN and AWS region from instance metadata\n",
INSTANE_ARN=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}' )
CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster' | awk -F/ '{print $NF}' )
REGION=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F: '{print $4}')

# Specify the logspout task definition to run at launch
TASK_DEF_LOGSPOUT=${task_definition_logspout}

# Run the AWS CLI start-task command to start logging to papertrailapp on this container instance\n",
COMMAND_LOGSPOUT="aws ecs start-task --cluster $CLUSTER \
           --task-definition $TASK_DEF_LOGSPOUT \
           --container-instances $INSTANE_ARN \
           --started-by $INSTANE_ARN \
           --region $REGION"

echo $COMMAND_LOGSPOUT >> /etc/rc.local
echo "" >> /etc/rc.local

# Specify the cAdvisor task definition to run at launch
TASK_DEF_CADVISOR=${task_definition_cadvisor}

#Run the AWS CLI start-task command to start cAdvisor on this container instance\n",
COMMAND_CADVISOR="aws ecs start-task --cluster $CLUSTER \
           --task-definition $TASK_DEF_CADVISOR \
           --container-instances $INSTANE_ARN \
           --started-by $INSTANE_ARN \
           --region $REGION"

echo $COMMAND_CADVISOR >> /etc/rc.local

# Specify the node_exporter task definition to run at launch
TASK_DEF_NODE_EXPORTER=${task_definition_node_exporter}

#Run the AWS CLI start-task command to start node_exporter on this container instance\n",
COMMAND_NODE_EXPORTER="aws ecs start-task --cluster $CLUSTER \
           --task-definition $TASK_DEF_NODE_EXPORTER \
           --container-instances $INSTANE_ARN \
           --started-by $INSTANE_ARN \
           --region $REGION"

echo $COMMAND_NODE_EXPORTER >> /etc/rc.local

$COMMAND_LOGSPOUT
$COMMAND_CADVISOR
$COMMAND_NODE_EXPORTER
