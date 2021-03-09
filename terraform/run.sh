#!/usr/bin/env bash

for r in $(terraform state list | grep "null_resource.run"); do terraform taint "$r"; done

terraform apply --var-file all.tfvars --auto-approve
