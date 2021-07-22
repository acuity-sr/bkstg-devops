rem globals
set GH_ORG=acuity-sr
set GH_REPO=acuity-bkstg
set REGION_NAME=eastus
set STAGE=dev

rem customize if you want the app-name to be different
set APP_NAME=%GH_REPO%-%STAGE%-%REGION%

pushd %~dp0
set SCRIPT_ROOT=%CD%
popd
SRC_DIR=%SCRIPT_DIR%/..

