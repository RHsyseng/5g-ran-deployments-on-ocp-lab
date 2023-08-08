#!/bin/bash

DIR=~/ansible-collections

for path in ${DIR}/*.tar.gz; do
    filename=$(basename ${path} .tar.gz)
    readarray -d "-" -t filearray <<< "$filename"
    NAMESPACE=${filearray[0]}
    COLLECTION=${filearray[1]}
    VERSION=$(${filearray[2]}|tr -d '\n')
    echo "Uploading ${NAMESPACE}-${COLLECTION}-${VERSION}"
    #create namespace
    curl -sku ${GALAXY_NG_USER}:"${GALAXY_NG_PASSWORD}" -X POST -H 'Content-Type: application/json' -d '{"name":"'${NAMESPACE}'","groups":[]}' ${GALAXY_NG_URL}/api/galaxy/_ui/v1/namespaces/ | jq
    #publish collection
    ansible-galaxy collection publish "${DIR}/${NAMESPACE}-${COLLECTION}-${VERSION}.tar.gz" -s ${GALAXY_NG_URL} --token $(cat /opt/galaxy_token) --ignore-certs
    #approve collection
    curl -sku ${GALAXY_NG_USER}:"${GALAXY_NG_PASSWORD}" -X POST -H 'Content-Type: application/json' "${GALAXY_NG_URL}"/api/galaxy/v3/collections/"${NAMESPACE}"/"${COLLECTION}"/versions/"${VERSION}"/move/staging/published/ | jq
done


