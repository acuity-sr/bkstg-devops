#!/usr/bin/env sh

echo "\n\n*************************"
echo     "4. Installing Helm Chart"
echo     "*************************\n\n"


start=$(date +"%D %T")
echo "Start: ${start}"
helm install happy-panda ${DEVOPS_SCRIPT_DIR}/../helmCharts
end=$(date +"%D %T")
echo "End: ${end}"


set +e
set -o
kubectl get pods -w
kubectl get service bkstg-api -w
