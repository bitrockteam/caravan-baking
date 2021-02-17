# Caravan Baking

## Requirements

* Terraform
* Packer
* Ansible

## AWS

```shell
cd terraform

cat <<EOF > aws.tfvars
build_on_aws      = true
build_image_name  = "caravan-centos-image"
aws_access_key    = "YOUR-ACCESS-KEY"
aws_secret_key    = "YOUR-SECRET-KEY"
aws_region        = "eu-central-1"
aws_instance_type = "t3.small"
EOF

terraform init
terraform apply -var-file aws.tfvars
```

## GCP

```shell
cd terraform

cat <<EOF > gcp.tfvars
build_on_google             = true
build_image_name            = "caravan-centos-image"
google_project_id           = "YOUR-PROJECT-ID"
google_account_file         = "YOUR-JSON-KEY"
google_network_name         = "caravan-gcp-vpc"
google_subnetwork_name      = "caravan-gcp-subnet"
EOF

terraform apply -var-file gcp.tfvars
```


## Azure

```shell
cd terraform

cat <<EOF > azure.tfvars
build_on_azure              = true
build_image_name            = "caravan-centos-image"
azure_subscription_id       = "YOUR-SUBSCRIPTION-ID"
azure_target_resource_group = "YOUR-RESOURCE-GROUP"
azure_client_id             = "YOUR-AZURE-CLIENT-ID"
azure_client_secret         = "YOUR-AZURE-CLIENT-SECRET"
EOF

terraform apply -var-file azure.tfvars
```


## Docs

[Terraform Docs](./terraform/README.md)
