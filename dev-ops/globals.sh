#!/usr/bin/env sh
# required
GH_ORG=acuity-sr
GH_REPO=bkstg-one

RELEASE=${RELEASE:?}
STAGE=${STAGE:-'main'}
REGION_NAME=${REGION_NAME:-'eastus'}

echo "${RELEASE} ${STAGE} ${REGION_NAME}"

# optional
SUBSCRIPTION_ID=d8f43804-1ed0-4f0d-b26d-77e8e11e86fd

# Customize APP_NAME to fit your needs.
# It's used as a prefix for all resources
# (even the ResourceGroup) created.
APP_NAME=${GH_REPO}-${STAGE}-${REGION_NAME}


# debug controls
set -e # stop on error
# set -x # echo commands, expand variables
# set -v # echo commands, do not expand variables


SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# the project src is typically one level up from the dev-ops "scripts" folder.
SRC_DIR=${SCRIPT_ROOT}/..

# convenience definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
# NO_COLOR
NC="\033[0m"


RESOURCE_GROUP=${APP_NAME}-rg


SERVICE_PRINCIPAL=${APP_NAME}-sp
SP_FNAME=./${SERVICE_PRINCIPAL}-creds.dat


SUBNET_NAME=${APP_NAME}-aks-subnet
VNET_NAME=${APP_NAME}-aks-vnet


AKS_CLUSTER_NAME=${APP_NAME}-${STAGE}-aks
KUBERNETES_NAMESPACE=${APP_NAME}

# this is what we'd have liked:
# since we only have one per RG, we'll just call it acr and move along.
# ACR_NAME=${APP_NAME}-${STAGE}-acr

# this is what we got:
# ACR_NAME must conform to '^[a-zA-Z0-9]*$' and length > 5
ACR_NAME=acuitybkstgacrsr

BKSTG_REPOSITORY=${APP_NAME}
BKSTG_IMAGE=${BKSTG_REPOSITORY}:${RELEASE}
