#!/usr/bin/env sh

echo "\n*****************"
echo   "* Bootstrapping *"
echo   "*****************\n\n"

# specify SUBSCRIPTION_ID here if you'd like to pin it to a specific one.
# by default, will ask you to login and use the SUBSCRIPTION_ID tied to your account
if [[ ${SUBSCRIPTION_ID} == '' ]]
then
  echo "Extracting Azure 'Subscription ID' from current login"

  # Opens a webpage to login to Azure and provides credentials to the azure-cli
  az login

  # Picks the subscription tied to the login above
  # az account show --query 'id' --output tsv
  SUBSCRIPTION_ID=$(az account show --query 'id' --output tsv)
fi

SUBSCRIPTION_NAME=$(az account show --subscription ${SUBSCRIPTION_ID} --query 'name')

if [[ ${SUBSCRIPTION_ID} == '' ]]
then
 echo "${RED}ERROR: Subscription ID not found${NC}"
 exit -1
else
 echo "${YELLOW}SUBSCRIPTION_ID:${CYAN} ${SUBSCRIPTION_ID} ${NC}"
 echo "${YELLOW}SUBSCRIPTION_NAME:${CYAN} ${SUBSCRIPTION_NAME} ${NC}"
fi



echo "\nResource Group '${RESOURCE_GROUP}'"

rgExists=$(az group exists -n ${RESOURCE_GROUP})

if [[ ${rgExists} == 'true' ]];
then
  echo "Reusing existing resource group '${RESOURCE_GROUP}'"
else
# elif [[ "${USE_CASE}" == "create" ]]
# then
  echo "Creating resource-group '${RESOURCE_GROUP}' ${REGION_NAME}"
  # echo "az group create --name ${RESOURCE_GROUP} --location ${REGION_NAME}"
  # trap return value of next command & discard. bash seems to treat it as an error.
  JUNK=$(az group create --name ${RESOURCE_GROUP} --location ${REGION_NAME})
  unset JUNK
# else
#   echo "${RED} ERROR: Can only create ResourceGroup with USE_CASE=create, not ${USE_CASE}${NC}"
#   exit -1
fi


RESOURCE_GROUP_ID=$(az group show --query 'id' -n ${RESOURCE_GROUP} -o tsv)

if [[ ${RESOURCE_GROUP_ID} == '' ]]
then
 echo "${RED}ERROR: RESOURCE_GROUP_ID not found${NC}"
 exit /b -1
else
 echo "${YELLOW}RESOURCE_GROUP_ID:${CYAN} ${RESOURCE_GROUP_ID} ${NC}"
fi



echo "\nActive Directory Application '${APP_NAME}'"

appExists=$(az ad app list --query '[].appId' -o tsv --display-name ${APP_NAME})

# fetch previously created app
if [[ ${appExists} != "" ]]
then
  echo "Reusing AD Application '${APP_NAME}'"
else
  # APP_ID not found, create new Active directory app
  _APP=$(az ad app create --display-name ${APP_NAME})
  echo "Created AD Application '${APP_NAME}'"
fi

# extract APP_ID (needed to create the service principal)
APP_ID=$(az ad app list --query '[].appId' -o tsv --display-name ${APP_NAME})

if [[ ${APP_ID} == '' ]]
then
 echo "${RED}ERROR: APP_ID not found${NC}"
 exit -1
else
 echo "${YELLOW}APP_ID:${CYAN} ${APP_ID} ${NC}"
fi




# create service principal and store/use encrypted credentials
echo "\n${YELLOW}SERVICE_PRINCIPAL: ${CYAN}${SERVICE_PRINCIPAL}${NC}"

if test -f ${SP_FNAME}
then
  # use previously encrypted credentials. Will prompt for 'password'
  node ${SCRIPT_ROOT}/bin/decrypt.js ${SP_FNAME}
  SP_CREDENTIALS=`cat ${SP_FNAME}.decrypted`
  . ${SP_FNAME}.env
  rm ${SP_FNAME}.env
  rm ${SP_FNAME}.decrypted
else
  SP_CREDENTIALS=$(az ad sp create-for-rbac \
    --sdk-auth \
    --name ${SERVICE_PRINCIPAL})
  echo ${SP_CREDENTIALS} > ${SP_FNAME}
  # encrypt secrets with 'password' for next iteration.
  node ${SCRIPT_ROOT}/bin/encrypt.js ${SP_FNAME}
  . ${SP_FNAME}.env
  rm ${SP_FNAME}.env
fi

SERVICE_PRINCIPAL_ID=$(az ad sp list --query '[].objectId' -o tsv --display-name ${SERVICE_PRINCIPAL})

if [[ ${SERVICE_PRINCIPAL}_ID == '' ]]
then
 echo "${RED}ERROR: SERVICE_PRINCIPAL_ID not found${NC}"
 echo "(in development, try deleting the credentials file '${SP_FNAME}' and retry)"
 exit /b -1
else
 echo "${YELLOW}SERVICE_PRINCIPAL_ID:${CYAN} ${SERVICE_PRINCIPAL}_ID ${NC}"
fi



echo "\n\n${GREEN}Bootstrap successful${NC}"

