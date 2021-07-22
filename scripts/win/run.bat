
rem initialize script dir (via https://stackoverflow.com/a/36351656)
pushd %~dp0
set SCRIPT_DIR=%CD%
popd

rem bootstrap
set GH_ORG=acuity-sr
set APP_NAME=acuity-bkstg
set SRC_DIR=../acuity-bkstg
set REGION_NAME=eastus
set RESOURCE_GROUP=%APP_NAME%-rg
call %SCRIPT_DIR%\bootstrap.bat

rem build
rem we use a build_app.bat in-lieu of a CI process when working locally
set GIT_REPO=https://github.com/$GH_ORG/$APP_NAME
set API_DIR=packages/backend
set UI_DIR=packages/frontend
call %SCRIPT_DIR%\build_app.bat

rem infra
call %SCRIPT_DIR%\create_infra.bat


rem config

call %SCRIPT_DIR%\create_kubernetes.bat

rem app

call %SCRIPT_DIR%\deploy_app.bat


