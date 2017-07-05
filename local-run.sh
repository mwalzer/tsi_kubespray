# set environment variables used by scripts in cloud-deploy/
export PORTAL_DEPLOYMENTS_ROOT="$PWD/deployments"
export PORTAL_APP_REPO_FOLDER="$PWD"
export PORTAL_DEPLOYMENT_REFERENCE="id-phnmnl-${config_file%.sh}"

deployment_dir="$PORTAL_DEPLOYMENTS_ROOT/$PORTAL_DEPLOYMENT_REFERENCE"
if [[ ! -d "$deployment_dir" ]]; then
    mkdir -p "$deployment_dir"
fi
printf 'Using deployment directory "%s"\n' "$deployment_dir"

export TF_VAR_cluster_name = "public-sponsored-k8s"
export TF_VAR_number_of_k8s_masters = "1"
export TF_VAR_number_of_k8s_masters_no_floating_ip = "2"
export TF_VAR_number_of_k8s_nodes_no_floating_ip = "1"
export TF_VAR_number_of_k8s_nodes = "2"
export TF_VAR_public_key_path = "~/.ssh/ext5-phenomenal-k8s.pub"
export TF_VAR_image = "Ubuntu16.04"
export TF_VAR_ssh_user = "ubuntu"
export TF_VAR_flavor_k8s_node = "f3fcc537-c1fc-4108-a174-eb5bf52e7481" 
export TF_VAR_flavor_k8s_master = "f3fcc537-c1fc-4108-a174-eb5bf52e7481"
export TF_VAR_network_name = "PhenoMeNal-k8s_private"
export TF_VAR_floatingip_pool = "ext-net"

# GlusterFS variables
export TF_VAR_flavor_gfs_node = "6a36101a-21c7-4b97-ac4d-9343fe784028"
export TF_VAR_image_gfs = "Ubuntu16.04"
export TF_VAR_number_of_gfs_nodes_no_floating_ip = "3"
export TF_VAR_gfs_volume_size_in_gb = "100"
export TF_VAR_ssh_user_gfs = "ubuntu"

ostack/deploy.sh
