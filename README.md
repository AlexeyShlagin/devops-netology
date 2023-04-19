В директории Terraform и ниже:

1.  Будут игнориованы файлы с раширением:
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json

2. Будут игнорированы override файлы:
override.tf
override.tf.json
*_override.tf
*_override.tf.json

3. Файлы CLI configuration
.terraformrc
terraform.rc

4.~
