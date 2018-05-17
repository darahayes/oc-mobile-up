
set -e

# get the full path to the directory this script is in

__dirname="$(cd "$(dirname "$0")" && pwd)"

# remove cluster data in between installs
rm -rf $__dirname/cluster-data/*

# oc cluster up params

service_catalog="true"
hawkular_metrics="false"
cluster_image="openshift/origin"
cluster_version="v3.9.0"
<<<<<<< HEAD
cluster_ip=${cluster_ip:-"192.168.99.100"}
=======
cluster_public_ip="127.0.0.1"
>>>>>>> 093364c... fix: crazy idea :)
cluster_local_instance="yes"
developer_user=${developer_user:-developer}

# Registry Configs for Ansible Service Broker

registry_org=aerogearcatalog
registry_username=$registry_username
registry_password=$registry_password

if [ "$registry_username" == "" ] || [ "$registry_password" == "" ]; then
  echo 'You must set the $registry_username and $registry_password variables. exiting...'
  exit 1
fi

if [ ! "$skip_oc_cluster_up" == "true" ]; then
  oc cluster up \
  --service-catalog="$service_catalog" \
  --routing-suffix="$cluster_public_ip.nip.io" \
  --public-hostname="$cluster_public_ip.xip.io" \
  --version="$cluster_version" \
  --image="$cluster_image" 

fi

## Setup the developer user with the right permissions

oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin $developer_user
oc adm policy add-cluster-role-to-user access-asb-role $developer_user

## Mobile Client Custom Resource Definition Setup

core_org=aerogear
core_branch=master

oc adm policy add-cluster-role-to-group system:openshift:templateservicebroker-client system:unauthenticated system:authenticated
oc create -f "https://raw.githubusercontent.com/$core_org/mobile-core/$core_branch/installer/roles/create-mobile-client-crd/files/mobile-client-crd.yaml"
oc create clusterrole mobileclient-admin --verb=create,delete,get,list,patch,update,watch --resource=mobileclients
oc adm policy add-cluster-role-to-group mobileclient-admin system:authenticated

## Ansible Service Broker Setup

echo "Installing Ansible Service Broker: organisation=$registry_org, container registry username=$registry_username"
$__dirname/scripts/provision-ansible-service-broker.sh "$registry_username" "$registry_password" "$registry_org" true latest "$cluster_ip" nip.io ansible-service-broker

oc login -u developer
oc project myproject