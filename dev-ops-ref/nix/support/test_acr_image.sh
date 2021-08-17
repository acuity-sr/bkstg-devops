#!/usr/bin/env bash

set -e
set -x

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. ${SCRIPT_DIR}/../../globals.sh
. ${SCRIPT_DIR}/bootstrap.sh

echo "${ACR_NAME} ${BKSTG_IMAGE}"
az acr login -n ${ACR_NAME}
docker pull ${ACR_NAME}.azurecr.io/${BKSTG_IMAGE}
docker run -p 7000:7000 ${ACR_NAME}.azurecr.io/${BKSTG_IMAGE}
