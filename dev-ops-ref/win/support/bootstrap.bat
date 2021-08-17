
echo "\n*****************"
echo   "* Bootstrapping *"
echo   "*****************\n\n"

if (%SUBSCRIPTION_ID% == '') (
  echo "Extracting Azure 'Subscription ID' from current login"
  rem Opens a webpage to login to Azure and provides credentials to the azure-cli
  az login

  rem Picks the subscription tied to the login above
  rem az account show --query 'id' --output tsv
  FOR /F "tokens=* USEBACKQ" %%g IN (`az account show --query 'id' --output tsv`) do (SET SUBSCRIPTION_ID=%%g)
)

if (%SUBSCRIPTION_ID% == '') (
  echo "%RED%ERROR: Subscription ID not found%NC%"
  exit /b -1
) else (
  echo "%YELLOW%SUBSCRIPTION_ID:%CYAN% %SUBSCRIPTION_ID% %NC%"
)



set RESOURCE_GROUP=%APP_NAME%-rg

echo "\nResource Group '%RESOURCE_GROUP%'"

FOR /F "tokens=* USEBACKQ" %%g IN (`az group exists -n %RESOURCE_GROUP%`) do (SET rgExists=%%g)


if (%rgExists%=='true') (
  echo "Reusing existing resource group '${RESOURCE_GROUP}'"
) else (
  if (%USE_CASE%=='create') (
    echo "Creating resource-group '%RESOURCE_GROUP%'"
    az group create \
      --name %RESOURCE_GROUP% \
      --location %REGION_NAME%
  ) else (
    echo "%RED% ERROR: Can only create ResourceGroup with USE_CASE=create, not %USE_CASE%%NC%"
    exit /b -1
  )
)
FOR /F "tokens=* USEBACKQ" %%g IN (`az group show --query 'id' -n %RESOURCE_GROUP%`) do (SET RESOURCE_GROUP_ID=%%g)

if (%RESOURCE_GROUP_ID% == '') (
  echo "%RED%ERROR: RESOURCE_GROUP_ID not found%NC%"
  exit /b -1
) else (
  echo "%YELLOW%RESOURCE_GROUP_ID:%CYAN% %RESOURCE_GROUP_ID% %NC%"
)



echo "\nActive Directory Application '%APP_NAME%'"

rem fetch previously created app
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad app list --query '[].appId' -o tsv --display-name %APP_NAME%`) do (SET APP_ID=%%g)

if (%APP_ID%=="") (
  if (%USE_CASE%=='create') (
    rem APP_ID not found, create new Active directory app
    az ad app create --display-name %APP_NAME%
    echo "created new App '%APP_NAME%'"
  ) else (
      echo "ERROR: Can only create App with USE_CASE=create, not %USE_CASE%"
      exit /b -1
  )
)

rem extract APP_ID (needed to create the service principal)
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad app list --query '[].appId' -o tsv --display-name %APP_NAME%`) do (SET APP_ID=%%g)

if (%APP_ID% == '') (
  echo "%RED%ERROR: APP_ID not found%NC%"
  exit /b -1
) else (
  echo "%YELLOW%APP_ID:%CYAN% %APP_ID% %NC%"
)



rem create service principal
echo "\nService Principal '%SERVICE_PRINCIPAL%'"

if exist %SP_FNAME% (
  echo "Reusing existing service principal %APP_NAME%-sp"
  node %SCRIPT_ROOT%/bin/decrypt.js %SP_FNAME%
  FOR /F "tokens=* USEBACKQ" %%g IN (`type %SP_FNAME%.decrypted`) do (SET SP_CREDENTIALS=%%g)
  call %SP_FNAME%.env
  del %SP_FNAME%.env
  del %SP_FNAME%.decrypted
) else (
  if( %USE_CASE% == 'create) (
    FOR /F "tokens=* USEBACKQ" %%g IN (
      $(az ad sp create-for-rbac \
        --sdk-auth \
        --skip-assignment \
        --name %SERVICE_PRINCIPAL%`) do (SET SP_CREDENTIALS=%%g)
    echo %SP_CREDENTIALS% > %SP_FNAME%
    node %SCRIPT_ROOT%/bin/encrypt.js %SP_FNAME%
    call %SP_FNAME%.env
    del %SP_FNAME%.env
  ) else (
    echo "ERROR: Cannot only create ServicePrincipal with USE_CASE='create', not %USE_CASE%"
    exit /b -1
  )
)
FOR /F "tokens=* USEBACKQ" %%g IN (`az ad sp list --query '[].objectId' -o tsv --display-name %SERVICE_PRINCIPAL%`) do (SET SERVICE_PRINCIPAL_ID=%%g)

if (%SERVICE_PRINCIPAL_ID% == '') (
  echo "%RED%ERROR: SERVICE_PRINCIPAL_ID not found%NC%"
  exit /b -1
) else (
  echo "%YELLOW%SERVICE_PRINCIPAL_ID:%CYAN% %SERVICE_PRINCIPAL_ID% %NC%"
)



echo "\n\n%GREEN%Bootstrap successful%NC%"

