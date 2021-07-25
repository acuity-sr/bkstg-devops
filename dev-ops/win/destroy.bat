
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


