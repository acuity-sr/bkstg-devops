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

