#!/usr/bin/env sh

echo "\n\n******************************"
echo "2. Provisioning infrastructure"
echo "******************************\n\n"

# create/reuse SUBNET
subnetExists=$(az network vnet subnet show \
    --resource-group ${RESOURCE_GROUP} \
    --vnet-name ${VNET_NAME} \
    --name ${SUBNET_NAME} \
    --query id -o tsv 2>/dev/null || echo "create")
if [[ ${subnetExists} == "create" ]]
then
  echo "Creating virtual network '${VNET_NAME}' and subnet '${SUBNET_NAME}'"
  TMP=$(az network vnet create \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION_NAME} \
    --name ${VNET_NAME} \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name ${SUBNET_NAME} \
    --subnet-prefixes 10.240.0.0/16)
else
  echo "Reusing virtual network '${VNET_NAME}' and subnet '${SUBNET_NAME}'"
fi

SUBNET_ID=$(az network vnet subnet show \
    --resource-group ${RESOURCE_GROUP} \
    --vnet-name ${VNET_NAME} \
    --name ${SUBNET_NAME} \
    --query 'id' -o tsv)

echo "${YELLOW}SUBNET_ID: ${CYAN}${SUBNET_ID}${NC}"




VERSION=$(az aks get-versions \
    --location ${REGION_NAME} \
    --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' \
    --output tsv)

# Check to see if the cluster already exists
aksExists=$(az aks show \
  --output tsv \
  --query "id" \
  --resource-group ${RESOURCE_GROUP} \
  --name ${AKS_CLUSTER_NAME}  2>/dev/null || echo 'create')
if [[ ${aksExists} == "create" ]]
then
  echo "Creating new AKS Cluster - this can take a while (~3-5 minutes)"
  start=$(date +"%D %T")
  echo "Start: ${start}"
  AKS_CLUSTER=$(az aks create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${AKS_CLUSTER_NAME} \
    --vm-set-type VirtualMachineScaleSets \
    --service-principal ${SP_CLIENT_ID} \
    --client-secret ${SP_CLIENT_SECRET} \
    --node-count 2 \
    --load-balancer-sku standard \
    --location ${REGION_NAME} \
    --kubernetes-version ${VERSION} \
    --network-plugin azure \
    --vnet-subnet-id ${SUBNET_ID} \
    --service-cidr 10.2.0.0/24 \
    --dns-service-ip 10.2.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --generate-ssh-keys )
  end=$(date +"%D %T")
  echo "End: ${end}"
else
  echo "Reusing AKS Cluster ${AKS_CLUSTER_NAME}"
  
  if [[ $? == 0 ]]
  then
    echo "${GREEN}Created new AKS Cluster ${AKS_CLUSTER_NAME}${NC}"
  fi
fi
# re-initialize CLUSTER_ID, in case we created it.
AKS_CLUSTER_ID=$(az aks show \
  --output tsv \
  --query "id" \
  --resource-group ${RESOURCE_GROUP} \
  --name ${AKS_CLUSTER_NAME} 2>/dev/null || echo "not-found");
if [[ ${AKS_CLUSTER_ID} == "not-found" ]]
then
  echo "${RED}AKS_CLUSTER_ID not found${NC}"
else
  echo "${YELLOW}AKS_CLUSTER_NAME: ${CYAN}${AKS_CLUSTER_NAME}${NC}"
  echo "${YELLOW}AKS_CLUSTER_ID: ${CYAN}${AKS_CLUSTER_ID}${NC}"
fi




echo "\nCheck cluster connectivity"

TMP=$(az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME)

kubectl get nodes

echo ""



nsExists=$(kubectl get namespace ${KUBERNETES_NAMESPACE} 2>/dev/null || echo "create")
if [[ $nsExists == 'create' ]]
then
  echo "Creating kubernetes namespace '${KUBERNETES_NAMESPACE}'"
  # create the name space
  kubectl create namespace ${KUBERNETES_NAMESPACE}
else
  echo "Reusing kubernetes namespace '${KUBERNETES_NAMESPACE}'"
fi

# fetch list of available namespaces after to confirm
echo "\nAvailable namespaces"
kubectl get namespace 


