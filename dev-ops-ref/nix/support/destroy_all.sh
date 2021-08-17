#!/usr/bin/env sh
echo "\n\n***************"
echo     "* Destroy_all *"
echo     "***************\n"




# echo "Deleting AKS cluster '${AKS_CLUSTER_NAME}'"

# if $(az aks show \
#   --output tsv \
#   --query "id" \
#   --resource-group ${RESOURCE_GROUP} \
#   --name ${AKS_CLUSTER_NAME}) 2>/dev/null
# then
#   echo "Initiating delete of AKS cluster ${AKS_CLUSTER_NAME}. This might take a while"
#   az aks delete --name ${AKS_CLUSTER_NAME} --resource-group ${RESOURCE_GROUP}
#   if [[$? == 0]]
#   then
#     echo "${GREEN}Deleted AKS Cluster ${AKS_CLUSTER_NAME}${NC}"
#   else
#     echo "${RED}ERROR: failed to delete AKS Cluster ${AKS_CLUSTER_NAME}${NC}"
#     exit -1
#   fi
# else
#   echo "${YELLOW}Skip deleting AKS Cluster ${AKS_CLUSTER_NAME}(not found)${NC}"
# fi




# networking (destroy)

# if $(az network vnet subnet show \
#     --resource-group ${RESOURCE_GROUP} \
#     --vnet-name ${VNET_NAME} \
#     --name ${SUBNET_NAME} \
#     --query id -o tsv) 2>/dev/null
# then
#   echo "deleting subnet ${SUBNET_NAME}"
#   $(az network vnet subnet delete \
#     --name ${SUBNET_NAME} \
#     --vnet-name ${VNET_NAME} \
#     --resource-group ${RESOURCE_GROUP} \
#     --subscription ${SUBSCRIPTION_ID})
#   if [[ $? == 0 ]]
#   then
#     echo "deleting virtual network ${VNET_NAME}"
#     $(az network vnet delete \
#       --name ${VNET_NAME} \
#       --resource-group ${RESOURCE_GROUP} \
#       --subscription ${SUBSCRIPTION_ID})
#   fi
#   if [[ $? == 0 ]]
#   then
#       echo "${GREEN}Deleted sub+vnet ${VNET_NAME}:${SUBNET_NAME}${NC}"
#   else
#       echo "${RED}ERROR: failed to delete sub+vnet ${VNET_NAME}:${SUBNET_NAME}${NC}"
#       exit -1
#   fi
# else
#   echo "${YELLOW}Skip deleting sub+vnet ${VNET_NAME}:${SUBNET_NAME}(not found)${NC}"
# fi



# bootstrap (destroy)
echo "${RED}delete ${YELLOW}SERVICE_PRINCIPAL ${CYAN}${SERVICE_PRINCIPAL} (${SERVICE_PRINCIPAL}_ID)${NC}"
az ad sp delete --id ${SERVICE_PRINCIPAL_ID}
rm ${SP_FNAME}
# echo "delete AD Application  ${APP_NAME} (${APP_ID})"
# az ad app delete --id ${APP_ID}
echo "${RED}delete ${YELLOW}RESOURCE_GROUP ${CYAN}${RESOURCE_GROUP} (${RESOURCE_GROUP}_ID)${NC}"
echo "this might take a few minutes..."
start=$(date +"%D %T")
echo "Start: ${start}"  
az group delete --resource-group ${RESOURCE_GROUP}
end=$(date +"%D %T")
echo "End: ${end}"
  
echo "\n\n${GREEN}Destroyed all resources successfully${NC}"

