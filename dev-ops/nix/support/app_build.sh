#!/usr/bin/env sh

echo "\n\n*************************"
echo     "3. Build Container Images"
echo     "*************************\n\n"

rm -rf build-app
mkdir -p build-app
cd build-app
gh release download ${RELEASE} --repo ${GH_ORG}/${GH_REPO} 

# build the API container

API_REPOSITORY=${APP_NAME}-api
API_IMAGE=${API_REPOSITORY}:${RELEASE}
API_IMAGE_EXISTS=$(az acr repository show-tags \
  --output tsv \
  --name ${ACR_NAME} \
  --repository ${API_REPOSITORY} \
  --query "[?contains(@, '${RELEASE}')]" || echo "not-found");
echo ${API_IMAGE_EXISTS}
echo ${API_IMAGE}
if [[ ${API_IMAGE_EXISTS} == "not-found" ]]
then
    echo "Building API docker image. This takes a few minutes (~6-8 min)"
    start=$(date +"%D %T")
    echo "Start: ${start}"

    tar -xf bkstg.api.tgz
    tar -xf packages/backend/dist/skeleton.tar.gz
    tar -xf packages/backend/dist/bundle.tar.gz
    cd packages/backend
    az acr build .\
        --resource-group ${RESOURCE_GROUP} \
        --registry ${ACR_NAME} \
        --image ${API_IMAGE}
    cd ../..

    end=$(date +"%D %T")
    echo "End: ${end} (start: ${start})"
else
    echo "Reusing existing API Image ${API_IMAGE}"
fi
echo "${YELLOW}API_IMAGE: ${CYAN}${API_IMAGE}${NC}"

echo "available images in '${API_REPOSITORY}'"
az acr repository show-tags \
  --name ${ACR_NAME} \
  --repository ${API_REPOSITORY}
echo ""


UI_REPOSITORY=${APP_NAME}-ui
UI_IMAGE=${UI_REPOSITORY}:${RELEASE}
UI_IMAGE_EXISTS=$(az acr repository show-tags \
  --output tsv \
  --name ${ACR_NAME} \
  --repository ${UI_REPOSITORY} \
  --query "[?contains(@, '${RELEASE}')]" || echo "not-found");
if [[ ${UI_IMAGE_EXISTS} == "not-found" ]]
then
    # build the UI container
    echo "Building UI docker image. This takes a few minutes (~6-8 minutes)"
    start=$(date +"%D %T")
    echo "Start: ${start}"
    set -x
    tar -xvf bkstg.ui.tgz
    cd packages/app
    az acr build .\
      --resource-group ${RESOURCE_GROUP} \
      --registry ${ACR_NAME} \
      --image ${APP_NAME}-ui:${RELEASE}
    cd ../..
    set +x

    end=$(date +"%D %T")
    echo "End: ${end} (start: ${start})"
else
    echo "Reusing existing UI Image ${UI_IMAGE}"
fi

echo "${YELLOW}UI_IMAGE: ${CYAN}${UI_IMAGE}${NC}"

# list the images available in the registry.
# allows verification in case something goes wrong
echo "available images in '${UI_REPOSITORY}'"
az acr repository show-tags \
  --name ${ACR_NAME} \
  --repository ${UI_REPOSITORY}
echo ""

# we are in the build-app directory - move to parent.
cd ..
