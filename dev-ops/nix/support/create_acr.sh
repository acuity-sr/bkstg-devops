#!/usr/bin/env sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


. ${SCRIPT_DIR}/../../globals.sh
. ${SCRIPT_DIR}/bootstrap.sh
echo "\n\n******************************"
echo "2. Provisioning infrastructure"
echo "******************************\n\n"

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

# verify that the ACR was actually created
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

. ${SCRIPT_DIR}/app_build.sh