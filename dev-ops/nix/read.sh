#!/usr/bin/env sh
DEVOPS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

USE_CASE=create
echo "\n\n======"
echo     " Read "
echo     "======\n\n"

. ${DEVOPS_SCRIPT_DIR}/../globals.sh

echo "\nGlobals"
echo   "-------"
echo "${YELLOW}GH_ORG= ${CYAN}${GH_ORG}${NC}"
echo "${YELLOW}GH_REPO= ${CYAN}${GH_REPO}${NC}"
echo "${YELLOW}REGION_NAME= ${CYAN}${REGION_NAME}${NC}"
echo "${YELLOW}STAGE= ${CYAN}${STAGE}${NC}"
echo "${YELLOW}SUBSCRIPTION_ID= ${CYAN}${SUBSCRIPTION_ID}${NC}"
echo "${YELLOW}APP_NAME= ${CYAN}${APP_NAME}${NC}"

echo "${YELLOW}SCRIPT_ROOT= ${CYAN}${SCRIPT_ROOT}${NC}"
echo "${YELLOW}SRC_DIR= ${CYAN}${SRC_DIR}${NC}"

set +e # ignore errors and keep going.
echo "\nBootstrap"
echo   "---------"
APP_ID=$(az ad app list --query '[].appId' -o tsv --display-name ${APP_NAME})
echo "${YELLOW}APP_ID= ${CYAN}${APP_ID}${NC}"

echo "${YELLOW}RESOURCE_GROUP= ${CYAN}${RESOURCE_GROUP}${NC}"
RESOURCE_GROUP_ID=$(az group show --query 'id' -n ${RESOURCE_GROUP})
echo "${YELLOW}RESOURCE_GROUP_ID= ${CYAN}${RESOURCE_GROUP_ID}${NC}"

echo "${YELLOW}SERVICE_PRINCIPAL= ${CYAN}${SERVICE_PRINCIPAL}${NC}"
echo "${YELLOW}SP_FNAME= ${CYAN}${SP_FNAME}${NC}"

echo "\nInfrastructure"
echo   "--------------"
echo "${YELLOW}SUBNET_NAME= ${CYAN}${SUBNET_NAME}${NC}"
echo "${YELLOW}VNET_NAME= ${CYAN}${VNET_NAME}${NC}"
echo "${YELLOW}AWS_CLUSTER_NAME= ${CYAN}${AWS_CLUSTER_NAME}${NC}"

# echo "\nKubernetes"
# echo   "----------"

# echo "\nApplication"
# echo   "-----------"

