#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# bootstrap
GH_ORG=acuity-sr
APP_NAME=acuity-bkstg
REGION_NAME=eastus
RESOURCE_GROUP=$APP_NAME-rg
. $SCRIPT_DIR/bootstrap.sh

# # build
# # we use a build_app.sh in-lieu of a CI process when working locally
# GIT_REPO=https://github.com/$GH_ORG/$APP_NAME
# API_DIR=packages/backend
# UI_DIR=packages/frontend
# . $SCRIPT_DIR/build_app.sh

# infra
SUBNET_NAME=$APP_NAME-aks-subnet
VNET_NAME=$APP_NAME-aks-vnet
. $SCRIPT_DIR/create_infra.sh

# # config
# . $SCRIPT_DIR/create_kubernetes.sh

# # app
# . $SCRIPT_DIR/deploy_app.bat


