#!/usr/bin/env sh
# retrieve cluster credentials and configure kubectl
TMP=$(az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME)

kubectl get nodes


# Create namespace for project as a k8s resource
  echo "
apiVersion: v1
kind: Namespace
metadata:
  name: ${K8S_NAMESPACE}
" > ${NS_FILE}


# generate api-deployment.yml - done as a shell script
# to avoid using helm at this point.
echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP}-api
spec:
  selector:
    matchLabels:
      app: ${APP}-api
  template:
    metadata:
      labels:
        app: ${APP}-api # the label for the pods and the deployments
    spec:
      containers:
      - name: ${APP}-api
        image: ${ACR_NAME}.azurecr.io/${APP}-api:${RELEASE} 
        imagePullPolicy: Always
        ports:
        - containerPort: 3000 # the application listens to this port
        resources:
          requests: # minimum resources required
            cpu: 250m
            memory: 64Mi
          limits: # maximum resources allocated
            cpu: 500m
            memory: 256Mi
        readinessProbe: # is the container ready to receive traffic?
          httpGet:
            port: 3000
            path: /healthz
        livenessProbe: # is the container healthy?
          httpGet:
            port: 3000
            path: /healthz
" > ${SCRIPT_ROOT}/k8s/api-deployment.yml

