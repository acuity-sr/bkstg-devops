#!/usr/bin/env sh

# command line parameters
STAGE=${1}
RELEASE=${2}

DEVOPS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

USE_CASE=create
echo "\n\n================="
echo     " Create Workflow "
echo     "=================\n\n"


. ${DEVOPS_SCRIPT_DIR}/pre-reqs.sh
. ${DEVOPS_SCRIPT_DIR}/../globals.sh
. ${DEVOPS_SCRIPT_DIR}/support/bootstrap.sh
. ${DEVOPS_SCRIPT_DIR}/support/app_build.sh
. ${DEVOPS_SCRIPT_DIR}/support/create_infra.sh
# . ${DEVOPS_SCRIPT_DIR}/support/create_kubernetes.sh
# . ${DEVOPS_SCRIPT_DIR}/app_deploy.sh
# . ${DEVOPS_SCRIPT_DIR}/support/destroy_all.sh


