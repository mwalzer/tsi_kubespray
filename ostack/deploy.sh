#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# (but allow for the error trap)
set -eE

# ostack
export PRIVATE_KEY="$PORTAL_DEPLOYMENTS_ROOT/$PORTAL_DEPLOYMENT_REFERENCE/vre.key"
export TF_VAR_public_key_path="$PORTAL_DEPLOYMENTS_ROOT/$PORTAL_DEPLOYMENT_REFERENCE/vre.key.pub"

eval $(ssh-agent -s)
ssh-add $PRIVATE_KEY

echo Setting up Terraform creds && \
  export TF_VAR_username=${OS_USERNAME} && \
  export TF_VAR_password=${OS_PASSWORD} && \
  export TF_VAR_tenant=${OS_TENANT_NAME} && \
  export TF_VAR_auth_url=${OS_AUTH_URL}

# make sure image is available in openstack
ansible-playbook "$PORTAL_APP_REPO_FOLDER/playbooks/import-openstack-image.yml"
ansible-playbook "$PORTAL_APP_REPO_FOLDER/playbooks/import-openstack-image.yml" \
	-e img_version="current" \
        -e img_prefix="Ubuntu-16.04" \
	-e url_prefix="http://cloud-images.ubuntu.com/xenial/" \
	-e url_suffix="xenial-server-cloudimg-amd64-disk1.img" \
	-e compress_suffix=""

export TF_VAR_image="ContainerOS-1409.7.0"
export TF_VAR_image_gfs="Ubuntu-16.04-current"
export TF_VAR_ssh_user="core"
export TF_VAR_ssh_user_gfs="ubuntu"

export KARGO_TERRAFORM_FOLDER=$PORTAL_APP_REPO_FOLDER'/kubespray/contrib/terraform/openstack'



cd $PORTAL_APP_REPO_FOLDER'/kubespray'
#terraform get $KARGO_TERRAFORM_FOLDER
terraform apply --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate' $KARGO_TERRAFORM_FOLDER

# Provision kubespray
ansible-playbook  -b --become-user=root -i contrib/terraform/openstack/hosts cluster.yml \
	--key-file "$PRIVATE_KEY" \
	-e bootstrap_os=coreos \
	-e cloud_provider="openstack" \
	-e kube_api_pwd=$TF_VAR_kube_api_pwd \
	-e cluster_name=$TF_VAR_cluster_name \
	-e helm_enabled="true" \
	-e kube_network_plugin="flannel" \
	-e bin_dir="/opt/bin"
	-e resolvconf_mode="host_resolvconf"

# Provision glusterfs
ansible-playbook -b --become-user=root -i contrib/terraform/openstack/hosts ./contrib/network-storage/glusterfs/glusterfs.yml \
	--key-file "$PRIVATE_KEY"

# TODO
# - Make sure that glusterfs nodes get bootstrapped if needed (link bootstrap roles if needed)
# - Add service that mimicks endpoint for glusterfs to avoid the endpoint going missing.

# We need to copy the no-ip yaml files for ansible to somewhere sensible
#terraform apply -state=contrib/terraform/openstack/terraform.tfstate -var-file=phenomenal-test-deploy.tfvars contrib/terraform/openstack
