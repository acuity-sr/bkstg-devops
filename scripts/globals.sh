#!/usr/bin/env sh
# globals
GH_ORG=acuity-sr
GH_REPO=acuity-bkstg
REGION_NAME=eastus
STAGE=dev

# possibly customize
APP_NAME=$GH_REPO-$STAGE-$REGION

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SRC_DIR=$SCRIPT_ROOT/..

