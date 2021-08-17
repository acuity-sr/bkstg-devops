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

# retrieve cluster credentials and configure kubectl
TMP=$(az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME)

kubectl get nodes



acrExists=$(az acr show \
  --output tsv \
  --query "id" \
  --name ${ACR_NAME}  2>/dev/null || echo 'create')
if [[ ${acrExists} == "create" ]]
then
  echo "Creating new ACR Registry ${ACR_NAME}"
  start=$(date +"%D %T")
  echo "Start: ${start}"
  ACR=$(az acr create \
    --resource-group $RESOURCE_GROUP \
      --location $REGION_NAME \
      --name $ACR_NAME \
      --sku Standard )
  end=$(date +"%D %T")
  echo "End: ${end}"
  if [[ $? == 0 ]]
  then
    echo "${GREEN}Created new ACR Registry ${ACR_NAME}${NC}"
  fi
else
  echo "Reusing AKS Cluster ${ACR_NAME}" 
fi
# re-initialize CLUSTER_ID, in case we created it.
ACR_ID=$(az acr show \
  --output tsv \
  --resource-group ${RESOURCE_GROUP} \
  --name ${ACR_NAME} 2>/dev/null || echo "not-found");
if [[ ${ACR_ID} == "not-found" ]]
then
  echo "${RED}ACR_NAME not found${NC}"
else
  echo "${YELLOW}ACR_NAME: ${CYAN}${ACR_NAME}${NC}"
fi


# Allow our AKS_CLUSTER to talk to the ACR Registry
az aks update \
    --name $AKS_CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    --attach-acr $ACR_NAME

