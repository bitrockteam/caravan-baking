# Caravan Baking

## OS Support (WIP)

In this table are summarized the currently tested OS setups for the diffrent cloud providers:

| Linux Family | Linux OS | Linux OS version |        aws         |         gcp        |          az        |        oci         |
|--|--|--|--|--|--|--|
|redhat	|centos| 7                           | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :x: |
|redhat	|centos| 8                           | :x:                | :x:                | :x:                | :x: |
|debian |ubuntu| 2004                        | :x:                | :heavy_check_mark: | :x:                | :x: |
|debian |ubuntu| 2104                        | :heavy_check_mark: | :heavy_check_mark: | :x:                | :x: |

## Requirements

* Terraform
* Packer
* Ansible

## AWS

```shell
cd terraform

cat <<EOF > aws.tfvars
build_on_aws      = true
aws_access_key    = "YOUR-ACCESS-KEY"
aws_secret_key    = "YOUR-SECRET-KEY"
aws_region        = "eu-central-1"
aws_instance_type = "t3.small"
linux_os          = "ubuntu"
linux_os_version  = "2104"
linux_os_family   = "debian"
ssh_username      = "ubuntu"
EOF

terraform init
terraform apply -var-file aws.tfvars
```

## GCP

```shell
cd terraform

cat <<EOF > gcp.tfvars
build_on_google         = true
google_project_id       = "YOUR-PROJECT-ID"
google_account_file     = "YOUR-JSON-KEY"
google_network_name     = "caravan-gcp-vpc"
google_subnetwork_name  = "caravan-gcp-subnet"
linux_os                = "ubuntu"
linux_os_version        = "2104"
linux_os_family         = "debian"
ssh_username            = "ubuntu"
EOF

terraform apply -var-file gcp.tfvars
```


## Azure

```shell
cd terraform

cat <<EOF > azure.tfvars
build_on_azure              = true
azure_subscription_id       = "YOUR-SUBSCRIPTION-ID"
azure_target_resource_group = "YOUR-RESOURCE-GROUP"
azure_client_id             = "YOUR-AZURE-CLIENT-ID"
azure_client_secret         = "YOUR-AZURE-CLIENT-SECRET"
linux_os                    = "ubuntu"
linux_os_version            = "2104"
linux_os_family             = "debian"
ssh_username                = "ubuntu"
EOF

terraform apply -var-file azure.tfvars
```


## Docs

[Terraform Docs](./terraform/README.md)
