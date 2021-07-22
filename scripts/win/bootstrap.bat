
echo "\n\n****************"
echo "1. Bootstrapping"
echo "****************\n\n"

rem specify SUBSCRIPTION_ID here if you'd like to pin it to a specific one.
rem by default, will ask you to login and use the SUBSCRIPTION_ID tied to your account
set SUBSCRIPTION_ID=

if (%SUBSCRIPTION_ID% == '') (
  echo "Extracting Azure 'Subscription ID' from current login"
  rem Opens a webpage to login to Azure and provides credentials to the azure-cli
  az login

  rem Picks the subscription tied to the login above
  rem az account show --query id --output tsv
  FOR /F "tokens=* USEBACKQ" %%g IN (`az account show --query id --output tsv`) do (SET SUBSCRIPTION_ID=%%g)

)
echo SUBSCRIPTION_ID=%SUBSCRIPTION_ID%




echo "Create resource group if it doesn't exist"
FOR /F "tokens=* USEBACKQ" %%g IN (`az group exists -n %RESOURCE_GROUP%`) do (SET rgExists=%%g)

if (%rgExists%=='false') (
  echo "Creating resource-group '%RESOURCE_GROUP%'"
  az group create \
    --name %RESOURCE_GROUP% \
    --location %REGION_NAME%
) else (
  echo "Reusing existing resource group '$RESOURCE_GROUP'"
)
FOR /F "tokens=* USEBACKQ" %%g IN (`az group show --query 'id' -n %RESOURCE_GROUP%`) do (SET RESOURCE_GROUP_ID=%%g)




echo "Create Active Directory App if not already existing"

rem fetch previously created app
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad app list --query [].appId -o tsv --display-name %APP_NAME%`) do (SET APP_ID=%%g)

if (%APP_ID%=="") (
  rem APP_ID not found, create new Active directory app
  az ad app create --display-name %APP_NAME%
  echo "created new App '%APP_NAME%'"
)

rem extract APP_ID (needed to create the service principal)
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad app list --query [].appId -o tsv --display-name %APP_NAME%`) do (SET APP_ID=%%g)

echo "APP_ID=%APP_ID%"



rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set SCRIPT_DIR=%CD%
popd


set SERVICE_PRINCIPAL=%APP_NAME%-sp
set SP_FNAME=./%APP_NAME%-sp-creds.dat
rem create service principal
if exist %SP_FNAME% (
  echo "Reusing existing service principal %APP_NAME%-sp"
  node %SCRIPT_DIR%/../bin/decrypt.js %SP_FNAME%
  FOR /F "tokens=* USEBACKQ" %%g IN (`type %SP_FNAME%.decrypted`) do (SET SP_CREDENTIALS=%%g)
  rm %SP_FNAME%.decrypted
) else (
  FOR /F "tokens=* USEBACKQ" %%g IN (`\
    az ad sp create-for-rbac \
      --sdk-auth \
      --skip-assignment \
      --name %SERVICE_PRINCIPAL%`) do (SET SP_CREDENTIALS=%%g)
  echo %SP_CREDENTIALS% > %SP_FNAME%
  node %SCRIPT_DIR%/../bin/encrypt.js %SP_FNAME%
)
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad sp list --query '[].objectId' -o tsv --display-name %SERVICE_PRINCIPAL%`) do (SET SERVICE_PRINCIPAL_ID=%%g)


