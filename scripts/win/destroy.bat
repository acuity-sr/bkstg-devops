
rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set SCRIPT_DIR=%CD%
popd

rem bootstrap
set APP_NAME=acuity-bkstg
set REGION_NAME=eastus
set RESOURCE_GROUP=%APP_NAME%-rg
call %SCRIPT_DIR%\bootstrap.bat

az group delete --resource-group %RESOURCE_GROUP% --no-wait


