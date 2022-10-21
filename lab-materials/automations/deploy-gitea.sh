#!/bin/bash

cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-gpte-gitea
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/gpte-devops-automation/gitea-catalog:latest
  displayName: Red Hat GPTE (Gitea)
  publisher: Red Hat GPTE
EOF

oc -n openshift-marketplace wait --for=jsonpath='{.status.connectionState.lastObservedState}'=READY catalogsource/redhat-gpte-gitea

cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: gitea-operator
  namespace: openshift-operators
spec:
  channel: "stable"
  name: gitea-operator
  source: redhat-gpte-gitea
  sourceNamespace: openshift-marketplace
EOF

oc -n openshift-operators wait $(oc -n openshift-operators get pod -l control-plane=controller-manager -o name) --for=condition=Ready

cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: gitea
EOF

cat <<EOF | oc apply -f -
apiVersion: gpte.opentlc.com/v1
kind: Gitea
metadata:
  name: gitea-server
  namespace: gitea
spec:
  giteaImageTag: 1.17.3
  giteaVolumeSize: 4Gi
  giteaSsl: true
  postgresqlVolumeSize: 4Gi
  giteaAdminUser: gitadmin
  giteaAdminPassword: "git4dmin!"
  giteaAdminEmail: "gitadmin@gitea.local"
  giteaCreateUsers: true
  giteaGenerateUserFormat: "student%d"
  giteaUserNumber: 3
  giteaUserPassword: openshift
EOF
