#!/bin/bash

REQUIREMENTS='./requirements.yml'

if [[ ! -f "$REQUIREMENTS" ]]; then
    echo "requirements.yml not defined in this directory"
    exit 1
fi

if [ -z "$GALAXY_NG_USER" ]; then
    echo "Set GALAXY_NG_USER env variable to the AAP Hub username"
    exit 1
fi

if [ -z "$GALAXY_NG_PASSWORD" ]; then
    echo "Set GALAXY_NG_PASSWORD env variable to the AAP Hub password"
    exit 1
fi

if [ -z "$GALAXY_NG_URL" ]; then
    echo "Set GALAXY_NG_URL env variable to the AAP Hub url"
    exit 1
fi

if [ -z "$GALAXY_TOKEN" ]; then
    echo "Set GALAXY_TOKEN env variable to the AAP Hub token"
    exit 1
fi

DIR='./collections'

if [ ! -d "$DIR" ]; then
    echo "Downloading collections from Galaxy"
    ansible-galaxy collection download -r requirements.yml
else
    echo "Using existing collections directory"
fi

echo "Creating ansible.cfg for populating private AAP Hub"
cat << EOF > ./ansible.cfg
[galaxy]
server_list = private_aap_server

[galaxy_server.private_aap_server]
url=${GALAXY_NG_URL}/api/galaxy/
token=${GALAXY_TOKEN}
EOF


for path in $DIR/*.tar.gz; do
    filename=$(basename ${path} .tar.gz)
    readarray -d "-" -t splitted <<< "$filename"
    NAMESPACE=${splitted[0]}
    COLLECTION=${splitted[1]}
    VERSION=${splitted[2]}
    VERSION=$(echo $VERSION|tr -d '\n')
    echo "Creating namespace, uploading, and approving for $NAMESPACE-$COLLECTION-$VERSION"
    curl -sku ${GALAXY_NG_USER}:"${GALAXY_NG_PASSWORD}" -X POST -H 'Content-Type: application/json' -d '{"name":"'$NAMESPACE'","groups":[]}' ${GALAXY_NG_URL}/api/galaxy/_ui/v1/namespaces/ | jq
    ansible-galaxy collection publish "$DIR/${NAMESPACE}-${COLLECTION}-${VERSION}.tar.gz" --ignore-certs
    curl -sku ${GALAXY_NG_USER}:"${GALAXY_NG_PASSWORD}" -X POST -H 'Content-Type: application/json' "${GALAXY_NG_URL}"/api/galaxy/v3/collections/"${NAMESPACE}"/"${COLLECTION}"/versions/"${VERSION}"/move/staging/published/ | jq
done

echo "Cleaning Up"

rm ./ansible.cfg
rm -rf ./collections

echo "Finished"


