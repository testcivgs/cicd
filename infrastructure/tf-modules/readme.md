Terraform reusable modules. Contains code for the services deployed in multiple environments.

To use modules, all you need is the following code:
```bash
module "frontend" {
  source = "/modules/frontend-app"
}
```

For more information read [How to create reusable infrastructure with Terraform modules](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d)
