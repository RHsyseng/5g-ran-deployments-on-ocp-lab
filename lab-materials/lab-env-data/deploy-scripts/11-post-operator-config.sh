!#/bin/bash

oc apply -f https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/hub-cluster/lvmcluster.yaml
oc -n openshift-storage wait lvmcluster odf-lvmcluster --for=jsonpath='{.status.ready}'=true --timeout=900s
oc patch storageclass odf-lvm-vg1 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

curl https://raw.githubusercontent.com/openshift-kni/cnf-features-deploy/master/ztp/gitops-subscriptions/argocd/deployment/argocd-openshift-gitops-patch.json -o /tmp/argopatch.json
oc patch argocd openshift-gitops -n openshift-gitops --type=merge --patch-file /tmp/argopatch.json
sleep 5
oc wait --for=condition=Ready pod -lapp.kubernetes.io/name=openshift-gitops-repo-server -n openshift-gitops
oc -n openshift-gitops adm policy add-cluster-role-to-user cluster-admin -z openshift-gitops-argocd-application-controller
