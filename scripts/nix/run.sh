#!/usr/bin/env sh
# bootstrap
GH_ORG=acuity-sr
APP_NAME=acuity-bkstg
REGION_NAME=eastus
RESOURCE_GROUP=$APP_NAME
. ./bootstrap.sh

# build
# we use a build_app.sh in-lieu of a CI process when working locally
GIT_REPO=https://github.com/$GH_ORG/$APP_NAME
API_DIR=packages/backend
UI_DIR=packages/frontend
. ./build_app.sh

# infra
SUBNET_NAME=$APP_NAME-aks-subnet
VNET_NAME=$APP_NAME-aks-vnet
. ./create_infra.sh

# config
. ./create_kubernetes.sh

# app
. ./deploy_app.bat


