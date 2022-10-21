#!/bin/bash

export OCP_Y="${OCP_Y:-4.11}"
export DISCONNECTED_REGISTRY="${DISCONNECTED_REGISTRY:-eko4.cloud.lab.eng.bos.redhat.com:8443}"

cat <<EOF > imageset.yaml
kind: ImageSetConfiguration
apiVersion: mirror.openshift.io/v1alpha2
storageConfig:
  registry:
    imageURL: ${DISCONNECTED_REGISTRY}/metadata:latest
    skipTLS: true
mirror:
  platform:
    channels:
      - name: stable-${OCP_Y}
        minVersion: ${OCP_Y}.3
        maxVersion: ${OCP_Y}.4
        type: ocp
    graph: true
  operators:
    - catalog: registry.redhat.io/redhat/redhat-operator-index:v${OCP_Y} # References entire catalog
      packages:
        - name: advanced-cluster-management
          channels:
             - name: 'release-2.6'
        - name: multicluster-engine
          channels:
             - name: 'stable-2.1'
        - name: local-storage-operator
          channels:
             - name: 'stable'
        - name: ocs-operator
          channels:
            - name: "stable-${OCP_Y}"
        - name: ptp-operator
          channels:
            - name: 'stable'
        - name: sriov-network-operator
          channels:
            - name: 'stable'
        - name: cluster-logging
          channels:
            - name: 'stable'
        - name: openshift-gitops-operator 
          channels:
            - name: 'latest'
    - catalog: registry.redhat.io/redhat/certified-operator-index:v${OCP_Y}
      packages:
        - name: sriov-fec
          channels:
            - name: 'stable'
    - catalog: registry.redhat.io/redhat/community-operator-index:v${OCP_Y}
      packages:
        - name: hive-operator
          channels:
            - name: 'alpha'
#    - catalog: registry.redhat.io/redhat/redhat-marketplace-index:v4.11
  additionalImages:
    - name: registry.redhat.io/ubi8/ubi:latest
    - name: quay.io/alosadag/troubleshoot:latest
  helm: {}
EOF

echo "downloading oc-mirror"
curl -O https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/oc-mirror.tar.gz
tar zxvf oc-mirror.tar.gz 
chmod +x oc-mirror
sudo mv oc-mirror /usr/local/bin/oc-mirror

echo "creating the imagesetconfig"
envsubst < imageset.yaml > imagesetconfig-${DISCONNECTED_REGISTRY}.yaml
rm -f imageset.yaml

echo "setting up credentials"
if [ ! -d "${HOME}/.docker" ]; then
  mkdir ~/.docker
else
  cp -i ./pull-secret.json ~/.docker/config.json
fi

echo "start mirroring..."
echo "oc-mirror --config="imagesetconfig-${DISCONNECTED_REGISTRY}.yaml" docker://${DISCONNECTED_REGISTRY} --dest-skip-tls  --source-skip-tls"
