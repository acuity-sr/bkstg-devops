
echo "\n\n******************************"
echo "2. Provisioning infrastructure"
echo "******************************\n\n"

set SUBNET_NAME=%APP_NAME%-aks-subnet
set VNET_NAME=%APP_NAME%-aks-vnet

rem check to see if previously created
FOR /F "tokens=* USEBACKQ" %%g IN (`az network vnet subnet show \
    --resource-group %RESOURCE_GROUP% \
    --vnet-name %VNET_NAME% \
    --name %SUBNET_NAME% \
    --query id -o tsv`) do (SET SUBNET_ID=%%g)

if ( SUBNET_ID == '') (
  echo "Creating virtual network '%VNET_NAME%' and subnet '%SUBNET_NAME%'"
  az network vnet create \
    --resource-group %RESOURCE_GROUP% \
    --location %REGION_NAME% \
    --name %VNET_NAME% \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name %SUBNET_NAME% \
    --subnet-prefixes 10.240.0.0/16
) else (
  echo "Reusing virtual network '%VNET_NAME%' and subnet '%SUBNET_NAME%'"
)

FOR /F "tokens=* USEBACKQ" %%g IN (`az network vnet subnet show \
    --resource-group %RESOURCE_GROUP% \
    --vnet-name %VNET_NAME% \
    --name %SUBNET_NAME% \
    --query id -o tsv`) do (SET SUBNET_ID=%%g)



FOR /F "tokens=* USEBACKQ" %%g IN (`az aks get-versions \
    --location %REGION_NAME% \
    --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' \
    --output tsv`) do (SET VERSION=%%g)

rem Check to see if the cluster already exists
FOR /F "tokens=* USEBACKQ" %%g IN (`az aks show \
    --name %AKS_CLUSTER_NAME%
    --output tsv`) do (SET AKS_CLUSTER_ID=%%g)

if (%AKS_CLUSTER_ID% == '') (
FOR /F "tokens=* USEBACKQ" %%g IN (`az aks create \
  --resource-group %RESOURCE_GROUP% \
  --name %AKS_CLUSTER_NAME% \
  --vm-set-type VirtualMachineScaleSets \
  --service-principal %SP_CLIENT_ID% \
  --clientSecret %SP_CLIENT_SECRET% \
  --node-count 2 \
  --load-balancer-sku standard \
  --location %REGION_NAME% \
  --kubernetes-version %VERSION% \
  --network-plugin azure \
  --vnet-subnet-id %SUBNET_ID% \
  --service-cidr 10.2.0.0/24 \
  --dns-service-ip 10.2.0.10 \
  --docker-bridge-address 172.17.0.1/16 \
  --generate-ssh-keys`) do (SET AKS_CLUSTER=%%g)
  echo "Created new cluster %AKS_CLUSTER_NAME%"
) else (
  echo "Reusing existing cluster %AKS_CLUSTER_NAME%"
)

rem refetch cluster_id, incase we just created it.
FOR /F "tokens=* USEBACKQ" %%g IN (`az aks show \
    --name %AKS_CLUSTER_NAME%
    --output tsv`) do (SET AKS_CLUSTER_ID=%%g)

if (%AKS_CLUSTER_ID% == '') (
  echo "%RED%AKS_CLUSTER_ID not found%NC%"
) else (
  echo "%YELLOW%AKS_CLUSTER_NAME: %CYAN%%AKS_CLUSTER_NAME%%NC%"
  echo "%YELLOW%AKS_CLUSTER_ID: %CYAN%%AKS_CLUSTER_ID%%NC%"
)

# retrieve cluster credentials and configure kubectl
az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME

kubectl get nodes




rem Check to see if the cluster already exists
FOR /F "tokens=* USEBACKQ" %%g IN (`az acr show \
    --name %ACR_NAME%
    --output tsv`) do (SET PREV_ACR=%%g)

if (%PREV_ACR% == '') (
  FOR /F "tokens=* USEBACKQ" %%g IN (`az acr create \
      --resource-group %RESOURCE_GROUP% \
      --location %REGION_NAME% \
      --name %ACR_NAME% \
      --sku Standard)
  echo "%GREEN%Created new registry %ACR_NAME%%NC%"
) else (
  echo "Reusing existing registry %ACR_NAME%"
)

echo "%YELLOW%ACR Registry %ACR_NAME%=%CYAN%%NC%"



rem Allow our AKS_CLUSTER to talk to the ACR Registry
az aks update \
    --name $AKS_CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    --attach-acr $ACR_NAME


