#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $SCRIPT_DIR/bootstrap.sh

az group delete --resource-group %RESOURCE_GROUP% --no-wait
az ad app delete --id $APP_ID
az ad sp delete

