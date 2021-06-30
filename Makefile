build-azure:
	cd terraform && terraform apply -var-file azure.tfvars

build-aws:
	cd terraform && terraform apply -var-file aws.tfvars

build-gcp:
	cd terraform && terraform apply -var-file gcp.tfvars
