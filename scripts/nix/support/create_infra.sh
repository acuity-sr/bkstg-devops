#!/usr/bin/env sh

echo "\n\n******************************"
echo "2. Provisioning infrastructure"
echo "******************************\n\n"


# check to see if previously created
SUBNET_ID=$(az network vnet subnet show \
    --resource-group ${RESOURCE_GROUP} \
    --vnet-name ${VNET_NAME} \
    --name ${SUBNET_NAME} \
    --query id -o tsv)

if [[ $? == 0 ]];
then
  echo "Reusing virtual network '${VNET_NAME}' and subnet '${SUBNET_NAME}'"
else
  echo "Creating virtual network '${VNET_NAME}' and subnet '${SUBNET_NAME}'"
  TMP=$(az network vnet create \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION_NAME} \
    --name ${VNET_NAME} \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name ${SUBNET_NAME} \
    --subnet-prefixes 10.240.0.0/16)
fi

SUBNET_ID=$(az network vnet subnet show \
    --resource-group ${RESOURCE_GROUP} \
    --vnet-name ${VNET_NAME} \
    --name ${SUBNET_NAME} \
    --query id -o tsv)

echo SUBNET_ID=${SUBNET_ID}




VERSION=$(az aks get-versions \
    --location ${REGION_NAME} \
    --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' \
    --output tsv)

# Check to see if the cluster already exists
AKS_CLUSTER_ID = $(az aks show \
  --output tsv \
  --query ".id" \
  --name ${AKS_CLUSTER_NAME})

if [[ ${AKS_CLUSTER_ID} == '' ]]
then
  AKS_CLUSTER =$(az aks create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${AKS_CLUSTER_NAME} \
    --vm-set-type VirtualMachineScaleSets \
    --node-count 2 \
    --load-balancer-sku standard \
    --location ${REGION_NAME} \
    --kubernetes-version ${VERSION} \
    --network-plugin azure \
    --vnet-subnet-id ${SUBNET_ID} \
    --service-cidr 10.2.0.0/24 \
    --dns-service-ip 10.2.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --generate-ssh-keys)
  if [[ $? == 0 ]]
  then
    echo "${GREEN}Created new AKS Cluster ${AKS_CLUSTER_NAME}${NC}"

else
  echo "Reusing AKS Cluster ${AKS_CLUSTER_NAME}"
fi
# re-initialize CLUSTER_ID, in case we created it.
AKS_CLUSTER_ID = $(az aks show \
  --output tsv \
  --query ".id" \
  --name ${AKS_CLUSTER_NAME})

  echo "${YELLOW}AKS Cluster ${AKS_CLUSTER_NAME}=${CYAN}AKS_CLUSTER_ID${NC}"
) else (
    echo "${RED}
)








