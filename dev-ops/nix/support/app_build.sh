#!/usr/bin/env sh
# need a release tag and a branch name here.
# download release tarball

mkdir -p build-app
cd build-app
gh release download ${RELEASE} --repo ${GH_ORG}/${GH_REPO} 

# build the API container
tar -xvf bkstg.api.tgz
cd packages/backend
az acr build \
    --resource-group ${RESOURCE_GROUP} \
    --registry ${ACR_NAME} \
    --image ${APP}-api:${RELEASE}
cd ../..

# build the UI container
tar -xvf bkstg.ui.tgz
cd packages/app
az acr build \
    --resource-group ${RESOURCE_GROUP} \
    --registry ${ACR_NAME} \
    --image ${APP}-ui:${RELEASE}
cd ../..

# list the images available in the registry.
# allows verification in case something goes wrong
az acr repository list \
    --name $ACR_NAME \
    --output table

# we are in the build-app directory - move to parent.
cd ..


