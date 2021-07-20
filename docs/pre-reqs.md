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

### 3. kubectl

### 4. heml

