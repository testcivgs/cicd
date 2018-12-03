Application deployment process without downtime

General description
---------

Described solution is set of Ansible and Terragrunt scripts (latest version of terraform and terragrunt), which provisions on  AWS following resources:
* VPC
* EC2 instances with Jenkins and bastion host
* 2 ECS clusters with load balancers, one per each environment
* ECR repository
* Route53 records for mgmt, dev and prod zones

Terraform global vars, which are located in `infrastructure/tf-life/global/vars/vars.tf` are being generated from `vars.tf.j2` via `generate-vars.sh` script.	

All infrastructiure is being created in Frankfurt region. Domain for orchestration provisioning: connected.express 

Simple 'Frontend' project is used for building Docker containers, which later will be orchestrated via ECS.

CI\CD
---------

Jenkins and Jenkins jobs are provisioned via ansible, vault file should be in /root/.vault.txt

Jenkins jobs are being delivered via `export-jenkins-job.sh` script.

Frontend job (`infrastructure/jenkins/frontend/Jenkinsfile`) has following stages:
* Get source. It checks by schedule master branch, if any commits were made, if yes - defines container image name, which will contain commit count, commit id and build number.
* Build and publish docker image. 
* Slack notification in project channel
  After this built images are being deleted and built docker image is delivered to DEV environment via deploy-service job.

Deploy-service job is used for deploying built containers to DEV or PROD ECS environment. This is parametrized job, which passes SERVICE and ENVIRONMENT parameters to `deploy-service.sh` script, which deploys new container to ECS cluster.

As frontend sample was chosen `nginxdemos/hello` container, which sends on 80 port container ID.
It should be running in ECS cluster in any desired quantity for fault tolerance.

Load balancer spreads requests between running containers and adds SSL certificates for `.prod` and `.dev` subdomains.

While ECS task update may cause some small downtime, for zero-time upgrade it is possible to scale tasks before update and leave them running under load balancer, and after update switch them off manually, or some automatization script mey be created depending on requirements.
