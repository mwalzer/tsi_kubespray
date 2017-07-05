#!/usr/bin/env bash

KARGO_TERRAFORM_FOLDER=$PORTAL_APP_REPO_FOLDER'/kubespray/contrib/terraform/openstack'

terraform get $KARGO_TERRAFORM_FOLDER
terraform apply --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate' $KARGO_TERRAFORM_FOLDER

# We need to copy the no-ip yaml files for ansible to somewhere sensible
#terraform apply -state=contrib/terraform/openstack/terraform.tfstate -var-file=phenomenal-test-deploy.tfvars contrib/terraform/openstack
