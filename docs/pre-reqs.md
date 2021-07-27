<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Pre-requisites](#pre-requisites)
  - [1. OS package manager:](#1-os-package-manager)
  - [2. nodejs:](#2-nodejs)
  - [(tl;dr - script to install the rest)](#tldr---script-to-install-the-rest)
  - [3. Azure CLI](#3-azure-cli)
  - [4. kubectl the Kubernetes-CLI](#4-kubectl-the-kubernetes-cli)
  - [5. kubectx & kubens](#5-kubectx--kubens)
  - [6. helm](#6-helm)
  - [7. github-cli](#7-github-cli)
  - [Checklist (scripts)](#checklist-scripts)
    - [`windows` (create win/pre-reqs.bat)](#windows-create-winpre-reqsbat)
    - [`*nix` (creates nix/pre-reqs.sh)](#nix-creates-nixpre-reqssh)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Pre-requisites

For a dev-ops flow to work smoothly, these are the minimum set of
utilities that we need installed. There are two modes in which the
dev-ops flow is designed to function - your personal machine and
github actions. For github-actions, we'll provide a working script with any instructions - typically will only involve fetching and setting up secrets for specific github organizations/repositories.

Your personal system however will need you to ensure that the list below is setup correctly.
In general, we assume we are working on `windows` or `macos` systems, though we generalize `macos` to `*nix` where possible.

## 1. OS package manager:

- `*nix`: builtin
- `macos`: [homebrew](https://brew.sh/) is a popular package manager and we'll be assuming this when necessary for the rest of the document.
  ```null
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- `windows`: [chocolatey](https://docs.chocolatey.org/en-us/choco/setup#non-administrative-install) is among the most popular package managers for windows and we'll be assuming this when necessary for the rest of the documents. It's most convenient to setup the non-administrative install of chocolatey.

## 2. nodejs:

If installing on your personal machine, it's best to install nodejs via the Node Version Manager, which allows multiple versions of node.js to coexist and switching between them as needed.

- `*nix`:
  - Install [nvm](https://github.com/nvm-sh/nvm#install--update-script)
  - Install LTS version of node.js and setup global dependencies
  ```null
    nvm install 14
    nvm use 14
    npm i yarn -g
  ```
- `windows`:
  - Install [nvm-windows](https://github.com/coreybutler/nvm-windows#installation--upgrades)
  - Install LTS version of node.js and setup global dependencies
  ```null
    nvm install 14
    nvm use 14
    npm i yarn -g
  ```

## (tl;dr - script to install the rest)

The remaining commands can be installed using the package managers we installed in step 1.
We also list the commands locations for manual installation in case your system is not listed below.

- windows

```null
choco install azure-cli
choco install kubernetes-cli
choco install kubens
choco install kubectx
choco install kubernetes-helm
choco install gh
```

- macos

```null
brew install azure-cli
brew install kubernetes-cli
brew install kubectx
brew install helm
brew install gh
```

Please see instructions for your flavour of \*nix at the links below.

## 3. Azure CLI

[Installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## 4. kubectl the Kubernetes-CLI

[Installation instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)

The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs. For more information including a complete list of kubectl operations, see the [kubectl reference documentation](https://kubernetes.io/docs/reference/kubectl/).

## 5. kubectx & kubens

[Installation intructions](https://github.com/ahmetb/kubectx/#installation)
Faster way to switch between clusters and namespaces in kubectl

## 6. helm

[Installation instructions](https://helm.sh/docs/intro/install/)

Helm is the package manager for Kubernetes, and you can read detailed background information in the [CNCF Helm Project Journey report](https://www.cncf.io/reports/cncf-helm-project-journey-report/).

## 7. github-cli

[Installation instructions](https://github.com/cli/cli#installation)
The github CLI - we use this to install github secrets when necessary

## Checklist (scripts)

While we cannot provide an automated installation script, we _can_ provide a checklist
script that can validate all pre-reqs are available and provide helpful text on the console
if not. This will make for a pleasant developer experience.

The checklist only looks for utilities that are essential for our dev-ops workflow
to function. Not all the pre-reqs listed above make the cut. Specifically, package managers (`choco`, `brew`), version managers (`nvm`) and optional utilities (`kubectx`).

### `windows` (create win/pre-reqs.bat)

```bat win/pre-reqs.bat
rem check that pre-reqs are installed

rem prints success messages for each binary tested
set TRACE='false'

set MISSING_REQS='false'
set CHOCO_INSTALLED='false'

where choco
if(%errorlevel% EQ 0) (
  set CHOCO_INSTALLED='true'
)

set RED="[31m [31m"
set GREEN="[31m [32m"
rem NO_COLOR
set NC="[0m" 

where node
if (%errorlevel% NEQ 0) (
  echo "MISSING %RED%node.js%NC%:"
  echo "  Install nvm-windows: https://github.com/coreybutler/nvm-windows#installation--upgrades"
  echo "  nvm install 14"
  echo "  nvm use 14"
  echo "  npm i yarn -g"
  MISSING_REQS='true'
) else (
  if (%TRACE% == 'true') (
    echo "%GREEN%node.js%NC%"
  )
)

where az
if (%errorlevel% NEQ 0) (
  set MESSAGE="MISSING %RED%azure-cli%NC%"
  if (%CHOCO_INSTALLED% == 'true') (
    echo "%MESSAGE%: choco install azure-cli
  ) else (
    echo "%MESSAGE%: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
  )
  MISSING_REQS='true'
) else (
  if (%TRACE% == 'true') (
    echo "%GREEN%azure-cli%NC%"
  )
)

where kubectl
if (%errorlevel% NEQ 0) (
  set MESSAGE="MISSING %RED%kubernetes-cli%NC%"
  if (%CHOCO_INSTALLED% == 'true') (
    echo "%MESSAGE%: choco install kubernetes-cli
  ) else (
    echo "%MESSAGE%: https://kubernetes.io/docs/tasks/tools/#kubectl"
  )
  MISSING_REQS='true'
) else (
  if (%TRACE% == 'true') (
    echo "%GREEN%kubernetes-cli%NC%"
  )
)

where helm
if (%errorlevel% NEQ 0) (
  set MESSAGE="MISSING %RED%helm%NC%"
  if (%CHOCO_INSTALLED% == 'true') (
    echo "%MESSAGE%: choco install kubernetes-helm
  ) else (
    echo "%MESSAGE%: https://helm.sh/docs/intro/install/"
  )
  MISSING_REQS='true'
) else (
  if (%TRACE% == 'true') (
    echo "%GREEN%helm%NC%"
  )
)

where gh
if (%errorlevel% NEQ 0) (
  set MESSAGE="MISSING %RED%github-cli%NC%"
  if (%CHOCO_INSTALLED% == 'true') (
    echo "%MESSAGE%: choco install gh
  ) else (
    echo "%MESSAGE%: https://github.com/cli/cli#installation"
  )
  MISSING_REQS='true'
) else (
  if (%TRACE% == 'true') (
    echo "%GREEN%github-cli%NC%"
  ))

rem finally, if we found missing pre-reqs, exit with error
if (%MISSING_REQS%=='true') (
  exit /b 255
)
```

### `*nix` (creates nix/pre-reqs.sh)

```sh nix/pre-reqs.sh
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
```
