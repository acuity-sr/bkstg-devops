#!/usr/bin/env sh

echo "\n\n****************"
echo "1. Bootstrapping"
echo "****************\n\n"

# specify SUBSCRIPTION_ID here if you'd like to pin it to a specific one.
# by default, will ask you to login and use the SUBSCRIPTION_ID tied to your account
SUBSCRIPTION_ID=
if [[ SUBSCRIPTION_ID == '' ]]
then
  echo "Extracting Azure 'Subscription ID' from current login"

  # Opens a webpage to login to Azure and provides credentials to the azure-cli
  az login

  # Picks the subscription tied to the login above
  # az account show --query id --output tsv
  SUBSCRIPTION_ID=`az account show --query id --output tsv`
fi
echo "SUBSCRIPTION_ID=$SUBSCRIPTION_ID"



echo "Create resource group if it doesn't exist"
rgExists=`az group exists -n $RESOURCE_GROUP`
if [ $? -eq 0 ];
then
  echo "Reusing existing resource group '$RESOURCE_GROUP'"
else
  echo "Creating resource-group '$RESOURCE_GROUP'"
  az group create \
    --name $RESOURCE_GROUP \
    --location $REGION_NAME
fi

RESOURCE_GROUP_ID=$(az group show --query 'id' -n $RESOURCE_GROUP)




echo "Create Active Directory App if not already existing"

# fetch previously created app
APP_ID=$(az ad app list --query [].appId -o tsv --display-name $APP_NAME)

if [ $? -ne 0 ];
then
  # APP_ID not found, create new Active directory app
  az ad app create --display-name $APP_NAME
  echo "created new App '$APP_NAME'"
fi

# extract APP_ID (needed to create the service principal)
APP_ID=`az ad app list --query [].appId -o tsv --display-name $APP_NAME`
echo "APP_ID=$APP_ID"




SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

SERVICE_PRINCIPAL="$APP_NAME-sp"
SP_FNAME="./$APP_NAME-sp-creds.dat"
if test -f $SP_FNAME
then
  node $SCRIPT_DIR/../bin/decrypt.js $SP_FNAME
  SP_CREDENTIALS=`cat $SP_FNAME.decrypted`
  rm $SP_FNAME.decrypted
else
  SP_CREDENTIALS=`
  az ad sp create-for-rbac \
    --sdk-auth \
    --skip-assignment\
    --name $SERVICE_PRINCIPAL`
  echo $SP_CREDENTIALS > $SP_FNAME
  node $SCRIPT_DIR/../bin/encrypt.js $SP_FNAME
fi

SERVICE_PRINCIPAL_ID=$(az ad sp list --query '[].objectId' -o tsv --display-name $SERVICE_PRINCIPAL)


