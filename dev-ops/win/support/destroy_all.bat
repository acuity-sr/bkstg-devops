echo "\n\n***************"
echo     "* Destroy_all *"
echo     "***************\n"



rem FOR /F "tokens=* USEBACKQ" %%g IN (`az aks show \
rem     --name %AKS_CLUSTER_NAME% \
rem     --output tsv`) do (SET AKS_CLUSTER_ID=%%g)
rem
rem if (%AKS_CLUSTER_ID% != '') (
rem   echo "Initiating delete of AKS cluster %AKS_CLUSTER_NAME%. This might take a while"
rem   az aks delete --name %AKS_CLUSTER_NAME% --resource-group %RESOURCE_GROUP%
rem   if (%errorlevel% == 0) (
rem       echo "%GREEN%Deleted AKS Cluster %AKS_CLUSTER_NAME%%NC%"
rem   ) else (
rem       echo "%RED%ERROR: failed to delete AKS Cluster %AKS_CLUSTER_NAME%%NC%"
rem       exit /b -1
rem   )
rem ) else (
rem   echo "%YELLOW%Skip deleting AKS Cluster %AKS_CLUSTER_NAME%(not found)%NC%"
rem )




rem networking (destroy)

rem fetch SUBNET_ID
rem FOR /F "tokens=* USEBACKQ" %%g IN (`az network vnet subnet show \
rem     --resource-group %RESOURCE_GROUP% \
rem     --vnet-name %VNET_NAME% \
rem     --name %SUBNET_NAME% \
rem     --query id -o tsv`) do (SET SUBNET_ID=%%g)
rem
rem if (%SUBNET_ID% != '') (
rem   echo "deleting subnet %SUBNET_NAME%"
rem   az network vnet subnet delete \
rem     --name %SUBNET_NAME% \
rem     --vnet-name %VNET_NAME% \
rem     --resource-group %RESOURCE_GROUP% \
rem     --subscription %SUBSCRIPTION_ID%
rem   if(%errorlevel% == 0) (
rem     echo "deleting virtual network %VNET_NAME%"
rem     az network vnet delete \
rem       --name %VNET_NAME% \
rem       --resource-group %RESOURCE_GROUP% \
rem       --subscription %SUBSCRIPTION_ID%
rem   )
rem   if (%errorlevel% == 0) (
rem       echo "%GREEN%Deleted sub+vnet %VNET_NAME%:%SUBNET_NAME%%NC%"
rem   ) else (
rem       echo "%RED%ERROR: failed to delete sub+vnet %VNET_NAME%:%SUBNET_NAME%%NC%"
rem       exit /b -1
rem   )
rem ) else (
rem   echo "%YELLOW%Skip deleting sub+vnet %VNET_NAME%:%SUBNET_NAME%(not found)%NC%"
rem )



rem bootstrap (destroy)
echo "delete SERVICE_PRINCIPAL %SERVICE_PRINCIPAL% (%SERVICE_PRINCIPAL_ID%)"
az ad sp delete --id %SERVICE_PRINCIPAL_ID%
del ${SP_FNAME}
echo "delete AD APPLICATION %APP_NAME% (%APP_ID%)"
az ad app delete --id %APP_ID%
echo "delete RESOURCE_GROUP %RESOURCE_GROUP% (%RESOURCE_GROUP_ID%)"
az group delete --resource-group %RESOURCE_GROUP%

