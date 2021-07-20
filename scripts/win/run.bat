rem bootstrap
set GH_ORG=acuity-sr
set APP_NAME=acuity-bkstg
set REGION_NAME=eastus
set RESOURCE_GROUP=%APP_NAME%
call bootstrap.bat

rem build
rem we use a build_app.bat in-lieu of a CI process when working locally
set GIT_REPO=https://github.com/$GH_ORG/$APP_NAME
set API_DIR=packages/backend
set UI_DIR=packages/frontend
call build_app.bat

rem infra
set SUBNET_NAME=%APP_NAME%-aks-subnet
set VNET_NAME=%APP_NAME%-aks-vnet
call create_infra.bat


rem config

call create_kubernetes.bat

rem app

call deploy_app.bat


