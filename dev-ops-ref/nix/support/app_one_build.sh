#!/usr/bin/env sh

# This builds a single 

echo "\n\n*************************"
echo     "3. Build Container Images"
echo     "*************************\n\n"

rm -rf build-app
mkdir -p build-app
cd build-app
gh release download ${RELEASE} --repo ${GH_ORG}/${GH_REPO} 

echo "RELEASE=${RELEASE} STAGE=${STAGE}"
# build bkstg container

BKSTG_IMAGE_EXISTS=$(az acr repository show-tags \
  --output tsv \
  --name ${ACR_NAME} \
  --repository ${BKSTG_REPOSITORY} \
  --query "[?contains(@, '${RELEASE}')]" | echo "not-found")
echo ${BKSTG_IMAGE_EXISTS}
echo ${BKSTG_IMAGE}
if [[ ${BKSTG_IMAGE_EXISTS} == "not-found" ]]
then
    echo "Building Backstage docker image. This takes a few minutes (~6-8 min)"
    start=$(date +"%D %T")
    echo "Start: ${start}"
    tar -xf bkstg-one.tgz && rm bkstg-one.tgz
    az acr build .\
        --resource-group ${RESOURCE_GROUP} \
        --registry ${ACR_NAME} \
        --image ${BKSTG_IMAGE}
    cd ../..

    end=$(date +"%D %T")
    echo "${PURPLE}End: ${end} (start: ${start})${NC}"
else
    echo "Reusing existing Backstage Image ${BKSTG_IMAGE}"
fi
echo "${YELLOW}BKSTG_IMAGE: ${CYAN}${BKSTG_IMAGE}${NC}"

echo "available images in '${BKSTG_REPOSITORY}'"
az acr repository show-tags \
  --name ${ACR_NAME} \
  --repository ${BKSTG_REPOSITORY}
echo ""

# we are in the build-app directory - move to parent.
cd ..
