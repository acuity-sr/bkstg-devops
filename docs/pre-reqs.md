# Pre-requisites

For a dev-ops flow to work smoothly, these are the minimum set of 
utilities that we need installed. There are two modes in which the 
dev-ops flow is designed to function - your personal machine and 
github actions. For github-actions, we'll provide a working script with any instructions - typically will only involve fetching and setting up secrets for specific github organizations/repositories.

Your personal system however will need you to ensure that the list below is setup correctly.
In general, we assume we are working on `windows` or `macos` systems, though we generalize `macos` to `*nix` where possible.

### 1. OS package manager:

- `*nix`: builtin
- `macos`: [homebrew](https://brew.sh/) is a popular package manager and we'll be assuming this when necessary for the rest of the document.
  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- `windows`: [chocolatey](https://docs.chocolatey.org/en-us/choco/setup#non-administrative-install) is among the most popular package managers for windows and we'll be assuming this when necessary for the rest of the documents. It's most convenient to setup the non-administrative install of chocolatey.

### 2. nodejs:

If installing on your personal machine, it's best to install nodejs via the Node Version Manager, which allows multiple versions of node.js to coexist and switching between them as needed.

- `*nix`:
  - Install [nvm](https://github.com/nvm-sh/nvm#install--update-script)
  - Install LTS version of node.js and setup global dependencies
  ```
    nvm install 14
    nvm use 14
    npm i yarn -g
  ```
- `windows`:
  - Install [nvm-windows](https://github.com/coreybutler/nvm-windows#installation--upgrades)
  - Install LTS version of node.js and setup global dependencies
  ```
    nvm install 14
    nvm use 14
    npm i yarn -g
  ```

## tl;dr
The remaining commands can be installed using the package managers we installed in step 1.
We also list the commands locations for manual installation in case your system is not listed below.

* windows
```null
choco install azure-cli
choco install kubernetes-cli
choco install kubens
choco install kubectx
choco install kubernetes-helm
choco install gh
```

* macos
```null
brew install azure-cli
brew install kubernetes-cli
brew install kubectx
brew install helm
brew install gh
```

Please see instructions for your flavour of *nix at the links below.

### 3. Azure CLI
[Installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### 4. kubectl the Kubernetes-CLI
[Installation instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)

The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs. For more information including a complete list of kubectl operations, see the [kubectl reference documentation](https://kubernetes.io/docs/reference/kubectl/).

### 5. kubectx & kubens
[Installation intructions](https://github.com/ahmetb/kubectx/#installation)
Faster way to switch between clusters and namespaces in kubectl

### 6. helm
[Installation instructions](https://helm.sh/docs/intro/install/)

Helm is the package manager for Kubernetes, and you can read detailed background information in the [CNCF Helm Project Journey report](https://www.cncf.io/reports/cncf-helm-project-journey-report/).

### 7. github-cli
[Installation instructions](https://github.com/cli/cli#installation)
The github CLI - we use this to install github secrets when necessary