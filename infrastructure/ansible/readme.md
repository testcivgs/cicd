Ansible is used to setup services on ec2 instances, for example jenkins, etc.

Ansible is run as a final step from ec2 user-data script:

```bash
# For example to setup jenkins master user-data runs ansible like this one:
ansible-playbook -i inventories/localhost playbooks/jenkins.yml --vault-password-file /root/.vault.txt
```
