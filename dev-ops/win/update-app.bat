
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


