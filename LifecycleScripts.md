## Lifecycle scripts

We first develop the lifecycle scripts needed to manage the different use cases.

To prevent catastrophic consequences, it's highly recommended that operators understand these scripts well
and invoke them with proper human review.

### Creation

Defines the workflow to implement the "Creation" use-case.
The script creates/reuses any necessary resources.

- `windows` (win/create.bat)

```bat win/create.bat

rem command line parameters
set STAGE=%1
set RELEASE=%2

rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set DEVOPS_SCRIPT_DIR=%CD%
popd

set USE_CASE=create
echo "\n\n================="
echo     " Create Workflow "
echo     "=================\n\n"

call %DEVOPS_SCRIPT_DIR%\pre-reqs.bat
call %DEVOPS_SCRIPT_DIR%\..\globals.bat
call %DEVOPS_SCRIPT_DIR%\support\bootstrap.bat
call %DEVOPS_SCRIPT_DIR%\support\app_build.bat
call %DEVOPS_SCRIPT_DIR%\support\create_infra.bat
call %DEVOPS_SCRIPT_DIR%\support\create_kubernetes.bat
call %DEVOPS_SCRIPT_DIR%\app_deploy.bat
rem call %DEVOPS_SCRIPT_DIR%\support\destroy_all.bat

```

- `*nix` (nix/create.sh)

```sh nix/create.sh

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

```

### Update Application

Updates the "application"

- `windows` (win/update-app.bat)

```bat win/update-app.bat

rem command line parameters
set STAGE=%1
set RELEASE=%2

rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set DEVOPS_SCRIPT_DIR=%CD%
popd

set USE_CASE=update-app
echo "\n\n================="
echo     " Update Workflow "
echo     "=================\n\n"

call %DEVOPS_SCRIPT_DIR%\pre-reqs.bat
call %DEVOPS_SCRIPT_DIR%\..\globals.bat
call %DEVOPS_SCRIPT_DIR%\support\bootstrap.bat
call %DEVOPS_SCRIPT_DIR%\support\app_build.bat
rem call %DEVOPS_SCRIPT_DIR%\support\create_infra.bat
rem call %DEVOPS_SCRIPT_DIR%\support\create_kubernetes.bat
call %DEVOPS_SCRIPT_DIR%\app_deploy.bat
rem call %DEVOPS_SCRIPT_DIR%\support\destroy_all.bat

```

- `*nix` (nix/update-app.sh)

```sh nix/update-app.sh

# command line parameters
STAGE=${1}
RELEASE=${2}

DEVOPS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

set USE_CASE=update-app
echo "\n\n================="
echo     " Update Workflow "
echo     "=================\n\n"

. ${DEVOPS_SCRIPT_DIR}/pre-reqs.sh
. ${DEVOPS_SCRIPT_DIR}/../globals.sh
. ${DEVOPS_SCRIPT_DIR}/support/bootstrap.sh
. ${DEVOPS_SCRIPT_DIR}/support/app_build.sh
# . ${DEVOPS_SCRIPT_DIR}/support/create_infra.sh
# . ${DEVOPS_SCRIPT_DIR}/support/create_kubernetes.sh
. ${DEVOPS_SCRIPT_DIR}/app_deploy.sh
# . ${DEVOPS_SCRIPT_DIR}/support/destroy_all.sh

```

### 1.3 Destroy

Destroys all provisioned infrastructure, including the "Service Principal" and "App" created during the bootstrap.
This is a kill-switch - meant to be used in development to shut down resources to save idle-billing of cloud resources.

- `windows` (win/destroy.bat)

```bat win/destroy.bat

rem command line parameters
set STAGE=%1
set RELEASE="Don't care"

rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set DEVOPS_SCRIPT_DIR=%CD%
popd

set USE_CASE=destroy
echo "\n\n=================="
echo     " Destroy Workflow "
echo     "==================\n\n"


call %DEVOPS_SCRIPT_DIR%\pre-reqs.bat
call %DEVOPS_SCRIPT_DIR%\..\globals.bat
call %DEVOPS_SCRIPT_DIR%\support\bootstrap.bat
rem call %DEVOPS_SCRIPT_DIR%\support\app_build.bat
rem call %DEVOPS_SCRIPT_DIR%\support\create_infra.bat
rem call %DEVOPS_SCRIPT_DIR%\support\create_kubernetes.bat
rem call %DEVOPS_SCRIPT_DIR%\app_deploy.bat
call %DEVOPS_SCRIPT_DIR%\support\destroy_all.bat

```

- `*nix` (nix/destroy.sh)

```sh nix/destroy.sh

# command line parameters
STAGE=${1}
RELEASE="Don't care"

DEVOPS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

set USE_CASE=destroy
echo "\n\n=================="
echo     " Destroy Workflow "
echo     "==================\n\n"

. ${DEVOPS_SCRIPT_DIR}/pre-reqs.sh
. ${DEVOPS_SCRIPT_DIR}/../globals.sh
. ${DEVOPS_SCRIPT_DIR}/support/bootstrap.sh
# . ${DEVOPS_SCRIPT_DIR}/support/app_build.sh
# . ${DEVOPS_SCRIPT_DIR}/support/create_infra.sh
# . ${DEVOPS_SCRIPT_DIR}/support/create_kubernetes.sh
# . ${DEVOPS_SCRIPT_DIR}/app_deploy.sh
. ${DEVOPS_SCRIPT_DIR}/support/destroy_all.sh

```
