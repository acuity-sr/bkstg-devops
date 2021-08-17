#!/usr/bin/env sh
# checks that pre-reqs are installed

# prints success messages for each binary tested
TRACE=true

MISSING_REQS=false
BREW_INSTALLED=true
if ! command -v brew &> /dev/null
then
  BREW_INSTALLED=false
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Checking for pre-requisites"
if ! command -v node &> /dev/null
then
  echo "  ${RED}node.js${NC}:"
  echo "    Install nvm: https://github.com/nvm-sh/nvm#install--update-script"
  echo "    nvm install 14"
  echo "    nvm use 14"
  echo "    npm i yarn -g"
  set MISSING_REQS=true
elif [[ $TRACE = true ]]
then
  echo "  ${GREEN}node.js${NC}"
fi

if ! command -v az &> /dev/null
then
  MESSAGE="  ${RED}azure-cli${NC}"
  if [[ $BREW_INSTALLED = true ]]
  then
    echo "$MESSAGE: brew install azure-cli"
  else
    echo "$MESSAGE: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
  fi
  set MISSING_REQS=true
elif [[ $TRACE = true ]]
then
  echo "  ${GREEN}azure-cli${NC}"
fi

if ! command -v kubectl &> /dev/null
then
  MESSAGE="  ${RED}kubernetes-cli${NC}"
  if [[ $BREW_INSTALLED = true ]]
  then
    echo "$MESSAGE: brew install kubernetes-cli"
  else
    echo "$MESSAGE: https://kubernetes.io/docs/tasks/tools/#kubectl"
  fi
  set MISSING_REQS=true
elif [[ $TRACE = true ]]
then
  echo "  ${GREEN}kubernetes-cli${NC}"
fi


if ! command -v helm &> /dev/null
then
  MESSAGE="MISSING ${RED}helm${NC}"
  if [[ $BREW_INSTALLED = true ]]
  then
    echo "$MESSAGE: brew install helm"
  else
    echo "$MESSAGE: https://helm.sh/docs/intro/install"
  fi
  set MISSING_REQS=true
elif [[ $TRACE = true ]]
then
  echo "  ${GREEN}helm${NC}"
fi


if ! command -v gh &> /dev/null
then
  MESSAGE="MISSING ${RED}github-cli${NC}"
  if [[ $BREW_INSTALLED = true ]]
  then
    echo "$MESSAGE: brew install gh"
  else
    echo "$MESSAGE: https://github.com/cli/cli#installation $BREW_INSTALLED"
  fi
  set MISSING_REQS=true
elif [[ $TRACE = true ]]
then
  echo "  ${GREEN}github-cli${NC}"
fi


# finally, if any pre-reqs were absent, exit with error
if [[ $MISSING_REQS == true ]]
then
  echo "Please install missing system dependencies and retry"
  exit -1
elif [[ $TRACE = false ]]
then
  echo "  ${GREEN}All good!${NC}"
fi

