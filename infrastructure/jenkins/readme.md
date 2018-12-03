# Manage Jenkins Jobs
## Create New Jenkins Job
### Requirements
* Configured working environment according to [Workspace Requirements](workspace-requirements.md)
* AWS is configured according to [AWS Initial Setup](aws-initial-setup.md)
* Jenkins is up and running according to [Jenkins Initial Bootstrap](../docs/jenkins.md)

## Create Job in infrastructure repo
* Create subdirectory equal to job name in [jenkins](../jenkins) and copy config.xml to it from one of the existing jobs.
* Create [Jenkinsfile](https://jenkins.io/doc/book/pipeline/) in project repository. If job doesn't have it's own github repository store Jenkinsfile in job subdirectory.
* Add Jenkins Job to Ansible. Add job name to variable ```jenkins_jobs``` in file [ ansible/vars/jenkins/vars.yml](../ansible/vars/jenkins/vars.yml).

## Export Job to Jenkins
### Get API Token
Get authentication API tokens from the jenkins instances for admin user: [http://jenkins.mgmt.connected.express/user/admin/configure](http://jenkins.mgmt.connected.express/user/admin/configure)

### Export Job to Jenkins (from local machine)

      ./export-jenkins-job.sh --name <JOB_NAME> --user <MY_USERNAME> --token <MY_API_TOKEN>

### Export Job to Jenkins (curl)

      JOB_NAME="<my_job_name>"
      JOB_FILE="<job_config_file_path>"
      USERNAME="<username>"
      TOKEN="<api_token>"

      CRUMB=$(curl -s "http://${USERNAME}:${TOKEN}@jenkins.mgmt.connected.express/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

      curl -k -X POST "http://${USERNAME}:${TOKEN}@jenkins.mgmt.conneted.express/createItem?name=${JOB_NAME}" --header "Content-Type: application/xml" --header "$CRUMB" -d @${JOB_FILE}

## Update existing Job (curl)

      JOB_NAME="<my_job_name>"
      JOB_FILE="<job_config_file_path>"
      USERNAME="<username>"
      TOKEN="<api_token>"

      CRUMB=$(curl -s "http://${USERNAME}:${TOKEN}@jenkins.mgmt.connected.express/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

      curl -k -X POST "http://${USERNAME}:${TOKEN}@jenkins.mgmt.connected.express/job/${JOB_NAME}/config.xml" --header "Content-Type: application/xml" --header "$CRUMB" -d @${JOB_FILE}
