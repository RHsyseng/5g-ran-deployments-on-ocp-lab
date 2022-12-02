#!/bin/bash

REGISTRY_NAME=infra.5g-deployment.lab

su - lab-user -c 'ssh-keygen -t rsa -b 2048 -f /home/lab-user/.ssh/id_rsa -q -N ""'
su - lab-user -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"

mkdir -p /etc/quay-install/certs/
cp 5g-ran-deployments-on-ocp-lab/lab-materials/helper-data/registry-*.pem /etc/quay-install/certs/
cp 5g-ran-deployments-on-ocp-lab/lab-materials/helper-data/registry-cert.pem /etc/pki/ca-trust/source/anchors/
update-ca-trust

curl -s -L https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/mirror-registry/latest/mirror-registry.tar.gz | sudo tar xvz -C /usr/bin
mirror-registry install --quayHostname ${REGISTRY_NAME} --sslKey /etc/quay-install/certs/registry-key.pem --sslCert /etc/quay-install/certs/registry-cert.pem --initUser admin --initPassword r3dh4t1! --ssh-key /home/lab-user/.ssh/id_rsa --targetUsername lab-user

echo "restarting the pod..."
systemctl restart quay-pod
until [ "`podman pod inspect -f {{.State}} quay-pod`" == "Running" ]; do
    sleep 5
done

echo "verify ssl connection..."
echo "Q" | openssl s_client -connect infra.5g-deployment.lab:8443

echo "mirroring the content..."
curl -s -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/oc-mirror.tar.gz | tar xvz -C /usr/bin
chmod u+x /usr/bin/oc-mirror
mkdir -p ~/.docker
cp /root/openshift_pull.json ~/.docker/config.json

oc-mirror --config=imageset-infra.yaml docker://${REGISTRY_NAME}:8443 --dest-skip-tls  --source-skip-tls --ignore-history
