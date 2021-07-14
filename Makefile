build-azure:
	cd terraform && terraform apply -var-file azure.tfvars -auto-approve

build-aws:
	cd terraform && terraform apply -var-file aws.tfvars -auto-approve

build-gcp:
	cd terraform && terraform apply -var-file gcp.tfvars -auto-approve
