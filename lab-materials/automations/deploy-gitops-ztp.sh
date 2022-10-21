#!/bin/bash

echo "installing openshift gitops operator"

cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-gitops-operator
  namespace: openshift-operators
spec:
  channel: stable 
  installPlanApproval: Automatic
  name: openshift-gitops-operator 
  source: redhat-operators 
  sourceNamespace: openshift-marketplace 
EOF

echo "waiting rollout of repo-server..."
oc wait --for=condition=Ready pod -lapp.kubernetes.io/name=openshift-gitops-repo-server -n openshift-gitops

echo "patching openshift-gitops for ZTP..."
curl -O  https://raw.githubusercontent.com/openshift-kni/cnf-features-deploy/master/ztp/gitops-subscriptions/argocd/deployment/argocd-openshift-gitops-patch.json
oc patch argocd openshift-gitops -n openshift-gitops  --type=merge --patch-file argocd-openshift-gitops-patch.json

echo "waiting rollout of repo-server..."
oc wait --for=condition=Ready pod -lapp.kubernetes.io/name=openshift-gitops-repo-server -n openshift-gitops
