rem required
set GH_ORG=acuity-sr
set GH_REPO=acuity-bkstg
set REGION_NAME=eastus
set STAGE=dev

rem optional
set SUBSCRIPTION_ID=d8f43804-1ed0-4f0d-b26d-77e8e11e86fd

rem Customize APP_NAME to fit your needs.
rem It's used as a prefix for all resources
rem (even the ResourceGroup) created.
set APP_NAME=%GH_REPO%-%STAGE%-%REGION%

pushd %~dp0
set SCRIPT_ROOT=%CD%
popd

rem the project src is typically one level up from the dev-ops "scripts" folder.
SRC_DIR=%SCRIPT_ROOT%/..

rem convenience definitions
set RED="[31m [31m"
set GREEN="[32m [32m"
set YELLOW="[33m [33m"
set BLUE="[34m [34m"
set PURPLE="[35m [35m"
set CYAN="[36m [36m"
rem NO_COLOR
set NC="[0m"


set RESOURCE_GROUP=%APP_NAME%-rg


set SERVICE_PRINCIPAL=%APP_NAME%-sp
set SP_FNAME=./%SERVICE_PRINCIPAL%-creds.dat


set SUBNET_NAME=%APP_NAME%-aks-subnet
set VNET_NAME=%APP_NAME%-aks-vnet


set AKS_CLUSTER_NAME=%APP_NAME%-%STAGE%-aks
set KUBERNETES_NAMESPACE=%APP_NAME%

