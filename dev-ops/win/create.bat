
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


