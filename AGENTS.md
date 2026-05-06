# 5G RAN RDS Deployments on OCP - Hands-on Lab

## Operation 1: Upgrade to a Newer OCP Release

When upgrading the lab from OCP `OLD` (e.g., 4.20) to `NEW` (e.g., 4.21), the following files must be updated. This checklist is ordered by priority.

1. Before making any changes, ask the user to provide the following information:

    1. Old OCP version (e.g: 4.20)
    2. New OCP version (e.g: 4.21)
    3. New minor OCP version 1 (e.g: 4.21.8)
    4. New minor OCP version 2 (e.g: 4.21.10)
    5. Old ACM version (e.g: 2.15)
    6. New ACM version (e.g: 2.16)
    7. Old MCE version (e.g: 2.10)
    8. New MCE version (e.g: 2.11)
    9. Old cluster logging channel (e.g: stable-6.4)
    10. New cluster logging channel (e.g: stable-6.5)

2. Gather required information for updating some files. IMPORTANT: USE THE SAME COMMANDS LISTED HERE, DO NOT MODIFY COMMANDS OTHER THAN THE RELEVANT PART TO THE NEW VERSION.

    1. RHCOS Live iso, Rootfs and ID info

        ~~~sh
        # Get existing folders, use new OCP version in the url and select the lowest:
        $ curl -Ls  https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.21/ | grep 'class="name"'
                            <span class="name">4.21.0</span>   <--- this is the lowest, use this in the next command
                            <span class="name">4.21.5</span>
                            <span class="name">latest</span>

        # Get existing isos/rootfs, from this you can infer RHCOS live-iso/rootfs URLs and filenames.
        $ curl -Ls  https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.21/4.21.0/ | grep 'class="name"' | grep 4.21 |grep -E "rootfs|live-iso"
                            <span class="name">rhcos-4.21.0-x86_64-live-iso.x86_64.iso</span>
                            <span class="name">rhcos-4.21.0-x86_64-live-rootfs.x86_64.img</span>

        # Get RHCOS info
        $ curl -Ls  https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.21/4.21.0/rhcos-id.txt
        9.6.20251212-1
        ~~~

    2. Red Hat Operator Index pinned version. THE LIST TAGS TAKES ~5 MINUTES, JUST WAIT FOR IT TO FINISH.

        ~~~sh
        # Make sure user is logged in 
        $ podman login registry.redhat.io
        # Get micro-tag for new OCP version
        $ skopeo list-tags docker://registry.redhat.io/redhat/redhat-operator-index | grep v4.21-
        <trimmed_output>
        "v4.21-1777504749",
        "v4.21-1777535607",
        "v4.21-1777535610",
        "v4.21-1777543645",
        "v4.21-1777562558",
        "v4.21-1777566263",
        "v4.21-1777571677",
        "v4.21-1777587557",
        "v4.21-1777899690", <-- select the one with the higher EPOCH
        <trimmed_output>
        # Make sure it exists, this will be the index micro-tag
        $ skopeo inspect --raw docker://registry.redhat.io/redhat/redhat-operator-index:v4.21-1777899690
        ~~~

    3. New kubernetes versions

        ~~~sh
        # Kubernetes version for new minor ocp version 1:
        $ oc adm release info 4.21.8 -o json | jq '"v\(.displayVersions.kubernetes.Version)"'
        1.34.5
        # Kubernetes version for new minor ocp version 2:
        $ oc adm release info 4.21.10 -o json | jq '"v\(.displayVersions.kubernetes.Version)"'
        1.34.6
        ~~~

3. Once we have the information we can proceed with the modification of the required files.

### Updating lab content files

Each section below represents a file that must be updated as part of the upgrade to a new OCP release. The path of the files is relative to the git repository root.

#### site.yml

Update references to the old OCP version with the new ones.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
content:
  sources:
    - url: ./
      branches:
      - 'lab-4.20'
      start_path: documentation

asciidoc:
  attributes:
    release-version: "4.20"
    page-pagination: true
    demo_environment: demo_environment_here
~~~

After:

~~~yaml
content:
  sources:
    - url: ./
      branches:
      - 'lab-4.21'
      start_path: documentation

asciidoc:
  attributes:
    release-version: "4.21"
    page-pagination: true
    demo_environment: demo_environment_here
~~~

#### documentation/antora.yml

Update name with the new OCP version.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
name: "4.20"
~~~

After:

~~~yaml
name: "4.21"
~~~

#### documentation/modules/ROOT/pages/_attributes.adoc

Update all the references to old OCP version to the new OCP version. Including the references to minor releases. This document will have references to major versions (e.g: 4.20) and minor (e.g: 4.20.8). There will be two minor versions in place, there will always be two, use `semver` for knowing which one is higher and lower.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
:branch: lab-4.20
:lab-major-version: 4.20
:openshift-release: v4.20
:openshift-previous-release: v4.19
:openshift-next-release: v4.20
:rds-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ref-design-overview_telco-ran-du
:rds-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ran-du-reference-configuration-crs
:rds-components: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ran-du-reference-design-components_telco-ran-du
:ran-rds-version-manifests: ran-rds-420-manifests
:policygen-common-file: common-420.yaml
:policygen-common-label: ocp420
:lvms-channel: stable-4.20
:catalogsource-index-image-tag: v4.20-1769431701
:ztp-sitegenerate-disconnected-image: infra.5g-deployment.lab:8443/openshift4/ztp-site-generate-rhel8:v4.20.0-1
:example-sno-clusterinstance-link: https://github.com/stolostron/siteconfig/blob/release-2.15/config/samples/siteconfig_v1alpha1_clusterinstance.yaml
:example-groupdu-policygen-link: https://github.com/openshift-kni/cnf-features-deploy/blob/release-4.20/ztp/gitops-subscriptions/argocd/example/policygentemplates/group-du-standard-ranGen.yaml
:reference-documentation: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/ztp-vdu-configuration-reference#ztp-du-firmware-config-reference_vdu-config-ref
:hub-cluster-ocp-version: v4.20.8
:hub-cluster-kubeversion: v1.33.6
:sno-cluster-version1: v4.20.8
:sno-cluster-version2: v4.20.10
:sno-seed-version: v4.20.8
:sno-cluster-version1-kubeversion: v1.33.6
:sno-cluster-version2-kubeversion: v1.33.6
:sno-cluster-version1-cvo: 4.20.8
:sno-cluster-version2-cvo: 4.20.10
:talm-update-file: zone-europe-upgrade-420-8.yaml
:talm-update-channel: stable-4.20
:talm-update-version: 4.20.10
:seed-image: infra.5g-deployment.lab:8443/ibi/lab5gran:v4.20.8
:talm-update-image: infra.5g-deployment.lab:8443/rhsysdeseng/lab5gran:v4.20.10
:talm-update-policy-name: version-420-1
:rhacm-version: v2.15
:multicluster-policygenerator-version: v2.15.0-1
:rhacm-template-processing: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.15/html/governance/governance#template-processing
:mce-version: v2.10
:policygentool-version: v4.20
:kcli-tools-tag: 4.20
:rhcos-rootfs-url: https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.20/4.20.0/rhcos-4.20.0-x86_64-live-rootfs.x86_64.img
:rhcos-rootfs-filename: rhcos-4.20.0-x86_64-live-rootfs.x86_64.img
:rhcos-liveiso-url: https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.20/4.20.0/rhcos-4.20.0-x86_64-live-iso.x86_64.iso
:rhcos-liveiso-filename: rhcos-4.20.0-x86_64-live-iso.x86_64.iso
:disconnected-registry-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/disconnected_environments/mirroring-in-disconnected-environments#installing-mirroring-creating-registry
:openshift-gitops-docs: https://docs.redhat.com/en/documentation/red_hat_openshift_gitops/1.18/html/understanding_openshift_gitops/about-redhat-openshift-gitops
:cnf-features-source-crs: https://github.com/openshift-kni/telco-reference/tree/release-4.20/telco-ran/configuration/source-crs
:cnf-features-siteconfig-gen: https://github.com/openshift-kni/cnf-features-deploy/tree/release-4.20/ztp/siteconfig-generator
:cnf-features-clustersgo: https://github.com/openshift-kni/cnf-features-deploy/blob/release-4.20/ztp/siteconfig-generator/siteConfig/clusterCRsV1.go
:cnf-features-siteconfig-plugin: https://github.com/openshift-kni/cnf-features-deploy/tree/release-4.20/ztp/siteconfig-generator-kustomize-plugin
:cnf-features-policygen-plugin: https://github.com/open-cluster-management-io/policy-generator-plugin
:rhacm-governance-doc: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.15/html/governance/governance
:ocp-cli-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/cli_tools/openshift-cli-oc#cli-about-cli_cli-developer-commands
:sno-preparing-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/installing_on_a_single_node/preparing-to-install-sno
:sno-installing-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/installing_on_a_single_node/install-sno-installing-sno#install-sno-generating-the-discovery-iso-with-the-assisted-installer_install-sno-installing-sno-with-the-assisted-installer
:sno-install-manually-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/installing_on_a_single_node/install-sno-installing-sno#install-sno-installing-sno-manually
:talm-cluster-upgrades-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/cnf-talm-for-cluster-updates
:talm-recovery-from-failed-upgrade-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#ztp-image-based-upgrade-procedure-cancel_ztp-gitops
:talm-precachingconfig-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/managing-cluster-policies-with-policygenerator-resources#talm-prechache-user-specified-images-concept_ztp-talm-pg
:workload-hints-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/cnf-understanding-low-latency
:ztp-gitops-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/ztp-preparing-the-hub-cluster
:nto-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/using-node-tuning-operator
:sriov-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/networking/hardware-networks#about-sriov
:sriov-supported-nics: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/networking/hardware-networks#supported-devices_about-sriov
:ptp-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/networking/using-precision-time-protocol-hardware#about-ptp
:workload-partitioning-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/enabling-workload-partitioning
:advanced-ztp-policy-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/managing-cluster-policies-with-policygentemplate-resources#ztp-adding-new-content-to-gitops-ztp_ztp-advanced-policy-config
:ztp-precaching-config-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/managing-cluster-policies-with-policygentemplate-resources#talm-prechache-user-specified-images-concept_ztp-talm
:mirror-registry-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/disconnected_environments/mirroring-in-disconnected-environments#installing-mirroring-creating-registry
:cluster-compare-tool-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/scalability_and_performance/comparing-cluster-configurations
:cluster-logging-channel: stable-6.4
:ibu-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-understanding-image-based-upgrade
:ibu-var-lib-containers: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade-shared-container-partition_shared-container-partition
:ibu-oadp: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/backup_and_restore/oadp-application-backup-and-restore#oadp-introduction
:ibu-oadp-prereq: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade-prep-oadp_cnf-non-gitops
:ibi-minimum-software: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-prereqs_ibi-understanding-image-based-install
:ibi-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-understanding-image-based-install
:ibi-openshift-install: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-edge-image-based-install
:ai-workflow: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/ztp-deploying-far-edge-sites#ztp-deploying-a-site_ztp-deploying-far-edge-sites
:seed-guidelines: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#seed-cluster-guidelines
:seed-prereq-software: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-prereqs_ibi-understanding-image-based-install
:seed-prereq-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-preparing-for-image-based-install
:seed-extramanifests: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-create-extra-manifest-configmap_ibi-edge-image-based-install
:seed-prereq-config-du-profile: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-seed-image-config-ran_ibi-preparing-image-based-install
:lca-seed-cluster-guidelines: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-understanding-image-based-install
:lca-ibu-stages: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade_understanding-image-based-upgrade
:lca-backup-restore: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-understanding-image-based-upgrade
:talm-ibgu-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#ztp-image-based-upgrade
~~~

After:

~~~yaml
:branch: lab-4.21
:lab-major-version: 4.21
:openshift-release: v4.21
:openshift-previous-release: v4.20
:openshift-next-release: v4.21
:rds-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ref-design-overview_telco-ran-du
:rds-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ran-du-reference-configuration-crs
:rds-components: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/telco-ran-du-ref-design-specs#telco-ran-du-reference-design-components_telco-ran-du
:ran-rds-version-manifests: ran-rds-421-manifests
:policygen-common-file: common-421.yaml
:policygen-common-label: ocp421
:lvms-channel: stable-4.21
:catalogsource-index-image-tag: v4.21-1777899690
:ztp-sitegenerate-disconnected-image: infra.5g-deployment.lab:8443/openshift4/ztp-site-generate-rhel8:v4.21.0-1
:example-sno-clusterinstance-link: https://github.com/stolostron/siteconfig/blob/release-2.15/config/samples/siteconfig_v1alpha1_clusterinstance.yaml
:example-groupdu-policygen-link: https://github.com/openshift-kni/cnf-features-deploy/blob/release-4.20/ztp/gitops-subscriptions/argocd/example/policygentemplates/group-du-standard-ranGen.yaml
:reference-documentation: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/edge_computing/ztp-vdu-configuration-reference#ztp-du-firmware-config-reference_vdu-config-ref
:hub-cluster-ocp-version: v4.21.8
:hub-cluster-kubeversion: <infered in 2.3>
:sno-cluster-version1: v4.21.8
:sno-cluster-version2: v4.21.10
:sno-seed-version: v4.21.8
:sno-cluster-version1-kubeversion: <infered in 2.3>
:sno-cluster-version2-kubeversion: <infered in 2.3>
:sno-cluster-version1-cvo: 4.21.8
:sno-cluster-version2-cvo: 4.21.10
:talm-update-file: zone-europe-upgrade-421-8.yaml
:talm-update-channel: stable-4.21
:talm-update-version: 4.21.10
:seed-image: infra.5g-deployment.lab:8443/ibi/lab5gran:v4.21.8
:talm-update-image: infra.5g-deployment.lab:8443/rhsysdeseng/lab5gran:v4.21.10
:talm-update-policy-name: version-421-1
:rhacm-version: v2.16
:multicluster-policygenerator-version: v2.16.0-1
:rhacm-template-processing: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.16/html/governance/governance#template-processing
:mce-version: v2.11
:policygentool-version: v4.21
:kcli-tools-tag: 4.21
:rhcos-rootfs-url: <infered in 2.1>
:rhcos-rootfs-filename: <infered in 2.1>
:rhcos-liveiso-url: <infered in 2.1>
:rhcos-liveiso-filename: <infered in 2.1>
:disconnected-registry-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/disconnected_environments/mirroring-in-disconnected-environments#installing-mirroring-creating-registry
:openshift-gitops-docs: https://docs.redhat.com/en/documentation/red_hat_openshift_gitops/1.19/html/understanding_openshift_gitops/about-redhat-openshift-gitops
:cnf-features-source-crs: https://github.com/openshift-kni/telco-reference/tree/release-4.21/telco-ran/configuration/source-crs
:cnf-features-siteconfig-gen: https://github.com/openshift-kni/cnf-features-deploy/tree/release-4.21/ztp/siteconfig-generator
:cnf-features-clustersgo: https://github.com/openshift-kni/cnf-features-deploy/blob/release-4.21/ztp/siteconfig-generator/siteConfig/clusterCRsV1.go
:cnf-features-siteconfig-plugin: https://github.com/openshift-kni/cnf-features-deploy/tree/release-4.21/ztp/siteconfig-generator-kustomize-plugin
:rhacm-governance-doc: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.16/html/governance/governance
:ocp-cli-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.1/html/cli_tools/openshift-cli-oc#cli-about-cli_cli-developer-commands
:sno-preparing-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/installing_on_a_single_node/preparing-to-install-sno
:sno-installing-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/installing_on_a_single_node/install-sno-installing-sno#install-sno-generating-the-discovery-iso-with-the-assisted-installer_install-sno-installing-sno-with-the-assisted-installer
:sno-install-manually-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/installing_on_a_single_node/install-sno-installing-sno#install-sno-installing-sno-manually
:talm-cluster-upgrades-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/cnf-talm-for-cluster-updates
:talm-recovery-from-failed-upgrade-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#ztp-image-based-upgrade-procedure-cancel_ztp-gitops
:talm-precachingconfig-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/managing-cluster-policies-with-policygenerator-resources#talm-prechache-user-specified-images-concept_ztp-talm-pg
:workload-hints-doc: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/cnf-understanding-low-latency
:ztp-gitops-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/ztp-preparing-the-hub-cluster
:nto-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/using-node-tuning-operator
:sriov-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/networking/hardware-networks#about-sriov
:sriov-supported-nics: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/networking/hardware-networks#supported-devices_about-sriov
:ptp-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/networking/using-precision-time-protocol-hardware#about-ptp
:workload-partitioning-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/enabling-workload-partitioning
:advanced-ztp-policy-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/managing-cluster-policies-with-policygentemplate-resources#ztp-adding-new-content-to-gitops-ztp_ztp-advanced-policy-config
:ztp-precaching-config-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/managing-cluster-policies-with-policygentemplate-resources#talm-prechache-user-specified-images-concept_ztp-talm
:mirror-registry-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/disconnected_environments/mirroring-in-disconnected-environments#installing-mirroring-creating-registry
:cluster-compare-tool-link: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/scalability_and_performance/comparing-cluster-configurations
:cluster-logging-channel: stable-6.5
:ibu-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-understanding-image-based-upgrade
:ibu-var-lib-containers: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade-shared-container-partition_shared-container-partition
:ibu-oadp: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/backup_and_restore/oadp-application-backup-and-restore#oadp-introduction
:ibu-oadp-prereq: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade-prep-oadp_cnf-non-gitops
:ibi-minimum-software: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-prereqs_ibi-understanding-image-based-install
:ibi-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-understanding-image-based-install
:ibi-openshift-install: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-edge-image-based-install
:ai-workflow: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/ztp-deploying-far-edge-sites#ztp-deploying-a-site_ztp-deploying-far-edge-sites
:seed-guidelines: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#seed-cluster-guidelines
:seed-prereq-software: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-prereqs_ibi-understanding-image-based-install
:seed-prereq-config: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-preparing-for-image-based-install
:seed-extramanifests: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-create-extra-manifest-configmap_ibi-edge-image-based-install
:seed-prereq-config-du-profile: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ztp-image-based-upgrade-seed-image-config-ran_ibi-preparing-image-based-install
:lca-seed-cluster-guidelines: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-installation-for-single-node-openshift#ibi-understanding-image-based-install
:lca-ibu-stages: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-image-based-upgrade_understanding-image-based-upgrade
:lca-backup-restore: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#cnf-understanding-image-based-upgrade
:talm-ibgu-docs: https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/edge_computing/image-based-upgrade-for-single-node-openshift-clusters#ztp-image-based-upgrade
~~~

#### lab-materials/hub-config/operators-config/00_rhacm_config.yaml

Update references to the disconnected catalog. You must use the microtag discovered in 2.2 and limit the epoch to the first 6 digits.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operator.open-cluster-management.io/v1
kind: MultiClusterHub
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    installer.open-cluster-management.io/mce-subscription-spec: '{"source": "cs-redhat-operator-index-v4-20-176943"}'
  name: multiclusterhub
  namespace: open-cluster-management
spec: 
  availabilityConfig: Basic
  overrides:
    components:
    - name: siteconfig
      enabled: true
~~~

After:

~~~yaml
apiVersion: operator.open-cluster-management.io/v1
kind: MultiClusterHub
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    installer.open-cluster-management.io/mce-subscription-spec: '{"source": "cs-redhat-operator-index-v4-21-177789"}'
  name: multiclusterhub
  namespace: open-cluster-management
spec: 
  availabilityConfig: Basic
  overrides:
    components:
    - name: siteconfig
      enabled: true
~~~

#### lab-materials/hub-config/operators-config/01_ai_config.yaml

Update AgentServiceConfig and ClusterImageSet. RHCOS version comes from the RHCOS id from step 2.1.

Example: 9.6.20251212-1 -> 96.20251212-1

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: agent-install.openshift.io/v1beta1
kind: AgentServiceConfig
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "2"
    unsupported.agent-install.openshift.io/assisted-service-configmap: 'assisted-service-config'
  name: agent
  namespace: multicluster-engine
spec:
  mirrorRegistryRef:
    name: custom-registries
  databaseStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
  filesystemStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
  osImages:
  - cpuArchitecture: x86_64
    openshiftVersion: "4.20"
    rootFSUrl: http://infra.5g-deployment.lab:8080/rhcos-4.20.0-x86_64-live-rootfs.x86_64.img
    url: http://infra.5g-deployment.lab:8080/rhcos-4.20.0-x86_64-live-iso.x86_64.iso
    version: 420.96.20250826-1
---
apiVersion: hive.openshift.io/v1
kind: ClusterImageSet
metadata:
  annotations:
        argocd.argoproj.io/sync-wave: "4"
  name: openshift-v4.20.8-disconnected
spec:
  releaseImage: infra.5g-deployment.lab:8443/openshift/release-images:4.20.8-x86_64
---
apiVersion: hive.openshift.io/v1
kind: ClusterImageSet
metadata:
  annotations:
        argocd.argoproj.io/sync-wave: "4"
  name: openshift-v4.20.10-disconnected
spec:
  releaseImage: infra.5g-deployment.lab:8443/openshift/release-images:4.20.10-x86_64
~~~

After:

~~~yaml
apiVersion: agent-install.openshift.io/v1beta1
kind: AgentServiceConfig
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "2"
    unsupported.agent-install.openshift.io/assisted-service-configmap: 'assisted-service-config'
  name: agent
  namespace: multicluster-engine
spec:
  mirrorRegistryRef:
    name: custom-registries
  databaseStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
  filesystemStorage:
    storageClassName: lvms-vg1
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
  osImages:
  - cpuArchitecture: x86_64
    openshiftVersion: "4.21"
    rootFSUrl: http://infra.5g-deployment.lab:8080/<rhcos rootfs filename infered in 2.1>
    url: http://infra.5g-deployment.lab:8080/<rhcos live iso filename infered in 2.1>
    version: 421.96.20251212-1
---
apiVersion: hive.openshift.io/v1
kind: ClusterImageSet
metadata:
  annotations:
        argocd.argoproj.io/sync-wave: "4"
  name: openshift-v4.21.8-disconnected
spec:
  releaseImage: infra.5g-deployment.lab:8443/openshift/release-images:4.21.8-x86_64
---
apiVersion: hive.openshift.io/v1
kind: ClusterImageSet
metadata:
  annotations:
        argocd.argoproj.io/sync-wave: "4"
  name: openshift-v4.21.10-disconnected
spec:
  releaseImage: infra.5g-deployment.lab:8443/openshift/release-images:4.21.10-x86_64
~~~

#### lab-materials/hub-config/operators-deployment/00_rhacm_deployment.yaml

Update channel and catalog.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: advanced-cluster-management
  namespace: open-cluster-management
spec:
  channel: "release-2.15"
  name: advanced-cluster-management
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: advanced-cluster-management
  namespace: open-cluster-management
spec:
  channel: "release-2.16"
  name: advanced-cluster-management
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
~~~

#### lab-materials/hub-config/operators-deployment/01_talm_deployment.yaml

Update catalog.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: topology-aware-lifecycle-manager
  namespace: openshift-operators
spec:
  channel: "stable"
  name: topology-aware-lifecycle-manager
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace

~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: topology-aware-lifecycle-manager
  namespace: openshift-operators
spec:
  channel: "stable"
  name: topology-aware-lifecycle-manager
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
~~~



#### lab-materials/hub-config/operators-deployment/02_mce_deployment.yaml

Update channel and catalog.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: multicluster-engine
  namespace: multicluster-engine
spec:
  channel: "stable-2.10"
  name: multicluster-engine
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: multicluster-engine
  namespace: multicluster-engine
spec:
  channel: "stable-2.11"
  name: multicluster-engine
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
~~~

#### lab-materials/hub-config/operators-deployment/03_ptp_deployment.yaml

Update catalog.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: ptp-operator
  namespace: openshift-ptp
spec:
  channel: "stable"
  name: ptp-operator
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: ptp-operator
  namespace: openshift-ptp
spec:
  channel: "stable"
  name: ptp-operator
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
~~~

#### lab-materials/hub-config/operators-deployment/04_logging_deployment.yaml

Update channel and catalog.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: cluster-logging
  namespace: openshift-logging
spec:
  channel: "stable-6.4"
  name: cluster-logging
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: loki-operator
  namespace: openshift-operators
spec:
  channel: "stable-6.4"
  name: loki-operator
  source: cs-redhat-operator-index-v4-20-176943
  sourceNamespace: openshift-marketplace
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: cluster-logging
  namespace: openshift-logging
spec:
  channel: "stable-6.5"
  name: cluster-logging
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  name: loki-operator
  namespace: openshift-operators
spec:
  channel: "stable-6.5"
  name: loki-operator
  source: cs-redhat-operator-index-v4-21-177789
  sourceNamespace: openshift-marketplace
~~~

#### lab-materials/lab-env-data/hub-cluster/argocd-patch.json

Update references to images.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~json
<trimmed file>
"image": "infra.5g-deployment.lab:8443/openshift4/ztp-site-generate-rhel8:v4.20.0-1"
<trimmed file>
"image": "infra.5g-deployment.lab:8443/rhacm2/multicluster-operators-subscription-rhel9:v2.15.0-1",
~~~

After:

~~~json
<trimmed file>
"image": "infra.5g-deployment.lab:8443/openshift4/ztp-site-generate-rhel8:v4.21.0-1"
<trimmed file>
"image": "infra.5g-deployment.lab:8443/rhacm2/multicluster-operators-subscription-rhel9:v2.16.0-1",
~~~


#### lab-materials/lab-env-data/hub-cluster/hub.yml

Update according to user input.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
plan: hub-cluster
force: false
version: stable
#disconnected_channel: fast
tag: "4.20.8"
cluster: "hub"
domain: 5g-deployment.lab
api_ip: 192.168.125.10
ingress_ip: 192.168.125.11
disconnected: True
disconnected_url: infra.5g-deployment.lab:8443
disconnected_update: True
disconnected_user: admin
disconnected_password: r3dh4t1!
disconnected_operators_version: v4.20-1769431701
disconnected_prefix: openshift/release-images
prega: False
disconnected_operators:
- name: advanced-cluster-management
  channels:
  - name: release-2.15
- name: multicluster-engine
  channels:
  - name: stable-2.10
- name: topology-aware-lifecycle-manager
  channels:
  - name: stable
- name: openshift-gitops-operator
  channels:
  - name: latest
- name: lvms-operator
  channels:
  - name: stable-4.20
- name: sriov-network-operator
  channels:
  - name: stable
- name: lifecycle-agent
  channels:
  - name: stable
- name: redhat-oadp-operator
  channels:
  - name: stable
- name: ptp-operator
  channels:
  - name: stable
- name: cluster-logging
  channels:
  - name: stable-6.4
- name: loki-operator
  channels:
  - name: stable-6.4
disconnected_extra_images:
- registry.redhat.io/openshift4/ztp-site-generate-rhel8:v4.20.0-1
# Image below is required for kustomize plugins
- registry.redhat.io/rhacm2/multicluster-operators-subscription-rhel9:v2.15.0-1
# Seed image for IBU
- quay.io/rhsysdeseng/lab5gran:v4.20.10
disconnected_extra_release: 4.20.10
disk_size: 120
extra_disks: [120]
memory: 26000
numcpus: 16
ctlplanes: 3
workers: 0
metal3: true
network: 5gdeploymentlab
users_dev: developer
users_devpassword: CHANGE_DEV_PWD
users_admin: admin
users_adminpassword: CHANGE_ADMIN_PWD
lvms_devices:
- /dev/vdb
apps:
- users
- openshift-gitops-operator
- lvms-operator
vmrules:
- hub-bootstrap: 
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:07
- hub-ctlplane-0:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:01
    - name: ptp-network
      # sriov: true creates virtual igb ifaces with ptp support
      sriov: true
- hub-ctlplane-1:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:02
    - name: ptp-network
      sriov: true
- hub-ctlplane-2:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:03
    - name: ptp-network
      sriov: true
~~~

After:

~~~yaml
plan: hub-cluster
force: false
version: stable
#disconnected_channel: fast
tag: "4.21.8"
cluster: "hub"
domain: 5g-deployment.lab
api_ip: 192.168.125.10
ingress_ip: 192.168.125.11
disconnected: True
disconnected_url: infra.5g-deployment.lab:8443
disconnected_update: True
disconnected_user: admin
disconnected_password: r3dh4t1!
disconnected_operators_version: v4.21-1777899690
disconnected_prefix: openshift/release-images
prega: False
disconnected_operators:
- name: advanced-cluster-management
  channels:
  - name: release-2.16
- name: multicluster-engine
  channels:
  - name: stable-2.11
- name: topology-aware-lifecycle-manager
  channels:
  - name: stable
- name: openshift-gitops-operator
  channels:
  - name: latest
- name: lvms-operator
  channels:
  - name: stable-4.21
- name: sriov-network-operator
  channels:
  - name: stable
- name: lifecycle-agent
  channels:
  - name: stable
- name: redhat-oadp-operator
  channels:
  - name: stable
- name: ptp-operator
  channels:
  - name: stable
- name: cluster-logging
  channels:
  - name: stable-6.5
- name: loki-operator
  channels:
  - name: stable-6.5
disconnected_extra_images:
- registry.redhat.io/openshift4/ztp-site-generate-rhel8:v4.21.0-1
# Image below is required for kustomize plugins
- registry.redhat.io/rhacm2/multicluster-operators-subscription-rhel9:v2.16.0-1
# Seed image for IBU
- quay.io/rhsysdeseng/lab5gran:v4.21.10
disconnected_extra_release: 4.21.10
disk_size: 120
extra_disks: [120]
memory: 26000
numcpus: 16
ctlplanes: 3
workers: 0
metal3: true
network: 5gdeploymentlab
users_dev: developer
users_devpassword: CHANGE_DEV_PWD
users_admin: admin
users_adminpassword: CHANGE_ADMIN_PWD
lvms_devices:
- /dev/vdb
apps:
- users
- openshift-gitops-operator
- lvms-operator
vmrules:
- hub-bootstrap: 
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:07
- hub-ctlplane-0:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:01
    - name: ptp-network
      # sriov: true creates virtual igb ifaces with ptp support
      sriov: true
- hub-ctlplane-1:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:02
    - name: ptp-network
      sriov: true
- hub-ctlplane-2:
    nets:
    - name: 5gdeploymentlab
      mac: aa:aa:aa:aa:01:03
    - name: ptp-network
      sriov: true

~~~

#### lab-materials/lab-env-data/hub-cluster/hub-operators-argoapps.yaml

Update targetRevision.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
    targetRevision: lab-4.20
~~~

After:

~~~yaml
    targetRevision: lab-4.21
~~~

#### lab-materials/lab-env-data/hub-cluster/sno1-argoapp.yaml

Update targetRevision.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
    targetRevision: lab-4.20
~~~

After:

~~~yaml
    targetRevision: lab-4.21
~~~

#### lab-materials/sno-config/02_logging_deployment.yaml

Update channel.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cluster-logging
  namespace: openshift-logging
  annotations:
    ran.openshift.io/ztp-deploy-wave: "2"
spec:
  channel: "stable-6.4"
  name: cluster-logging
  source: redhat-operator-index
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cluster-logging
  namespace: openshift-logging
  annotations:
    ran.openshift.io/ztp-deploy-wave: "2"
spec:
  channel: "stable-6.5"
  name: cluster-logging
  source: redhat-operator-index
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
~~~

#### lab-materials/sno-config/02_lvms_deployment.yaml

Update channel.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: lvms-operator
  namespace: openshift-storage
  annotations:
    ran.openshift.io/ztp-deploy-wave: "2"
spec:
  channel: "stable-4.20"
  name: lvms-operator
  source: redhat-operator-index
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
~~~

After:

~~~yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: lvms-operator
  namespace: openshift-storage
  annotations:
    ran.openshift.io/ztp-deploy-wave: "2"
spec:
  channel: "stable-4.21"
  name: lvms-operator
  source: redhat-operator-index
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
~~~

#### lab-materials/sno-deployment/02_extra_manifests.yaml

Update catalog image.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
  99-openshift-disconnected-catalog.yaml: |
    apiVersion: operators.coreos.com/v1alpha1
    kind: CatalogSource
    metadata:
      annotations:
        ran.openshift.io/ztp-deploy-wave: "1"
      name: redhat-operator-index
      namespace: openshift-marketplace
    spec:
      image: infra.5g-deployment.lab:8443/redhat/redhat-operator-index:v4.20-1769431701
      sourceType: grpc
~~~

After:

~~~yaml
  99-openshift-disconnected-catalog.yaml: |
    apiVersion: operators.coreos.com/v1alpha1
    kind: CatalogSource
    metadata:
      annotations:
        ran.openshift.io/ztp-deploy-wave: "1"
      name: redhat-operator-index
      namespace: openshift-marketplace
    spec:
      image: infra.5g-deployment.lab:8443/redhat/redhat-operator-index:v4.21-1777899690
      sourceType: grpc
~~~

#### lab-materials/sno-deployment/03_agentclusterinstall.yaml

Update reference to OCP release.

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
  imageSetRef:
    name: openshift-v4.20.8-disconnected
~~~

After:

~~~yaml
  imageSetRef:
    name: openshift-v4.21.8-disconnected
~~~

### Updating lab automation

Before starting the user must haved cloned this repository https://github.com/RHsyseng/agnosticd, ask the user for the absolute path so you can work within that path.

Each section below represents a file that must be updated as part of the upgrade to a new OCP release. The path of the files is relative to the git repository root provided by the user.

> **NOTE:** If the lab content files have already been updated (steps 1-3 of "Updating lab content files" completed), the agent can read `documentation/modules/ROOT/pages/_attributes.adoc` from the lab repo to derive all version values instead of re-running the discovery commands or asking the user again. Key mappings:
>
> | `_attributes.adoc` attribute | agnosticd variable |
> |---|---|
> | `catalogsource-index-image-tag` | tag portion of `disconnected_catalog_image` |
> | `rhcos-liveiso-filename` | `rhcos_live_image` |
> | `rhcos-rootfs-filename` | `rhcos_rootfs_image` |
> | `rhcos-liveiso-url` / `rhcos-rootfs-url` | path portion of `rhcos_live_image_url` / `rhcos_rootfs_image_url` |
> | `lab-major-version` | `ocp4_major_release`, `lab_version` (as `lab-X.Y`), `lab_release` |
> | `sno-cluster-version2-cvo` | `ocp4_minor_release` |

#### ansible/roles_ocp_workloads/ocp4_workload_5gran_deployments_lab/defaults/main.yml

Change references from OLD OCP version to NEW OCP version.
Change references to RHCOS files and URLs.
Change references to disconnected operator catalog

##### Example update from 4.20 (Old OCP version) to 4.21 (New OCP version)

Before:

~~~yaml
---
become_override: true
ocp_username: opentlc-mgr
silent: false
lab_version: "lab-4.20"
lab_release: "4.20"
repo_user: "RHsyseng"
platform_demo_redhat_com: true
student_name: "lab-user"
# yamllint disable rule:line-length
kcli_rpm: "https://github.com/{{ repo_user }}/5g-ran-deployments-on-ocp-lab/releases/download/{{ lab_release }}/kcli-99.0.0.git.202602040650.86cacd3-0.el9.x86_64.rpm"
lab_repo: "https://github.com/{{ repo_user }}/5g-ran-deployments-on-ocp-lab.git"
# yamllint enable rule:line-length
ocp4_major_release: "4.20"
ocp4_minor_release: "4.20.10"
lab_network_cidr: "192.168.125.0/24"
lab_network_domain: "5g-deployment.lab"
lab_sriov_domain: "sriov-network.lab"
lab_ptp_domain: "ptp-network.lab"
lab_sriov_cidr: "192.168.100.0/24"
lab_ptp_cidr: "192.168.200.0/24"
lab_registry_host: "infra.5g-deployment.lab:8443"
lab_api_host: "api.hub.5g-deployment.lab:6443"
upstream_dns: "1.1.1.1"
disconnected_update: false
download_rhcos_isos: false
install_lab_dependencies: false
hypervisor_min_memory_mb: 204800
# hypervisor_min_cpus: 128
hypervisor_min_cpus: 64
hypervisor_supported_distributions: ['RedHat', 'CentOS', 'Fedora']
lab_hub_vm_cpus: 16
lab_hub_vm_memory: 48000
lab_hub_vm_disk: 200
lab_sno_vm_cpus: 12
lab_sno_vm_memory: 24000
lab_sno_vm_disk: 200
extra_disk_libvirt_images: true
disconnected_catalog_image: infra.5g-deployment.lab:8443/redhat/redhat-operator-index:v4.20-1769431701
# yamllint disable rule:line-length
rhcos_live_image: 'rhcos-4.20.0-x86_64-live-iso.x86_64.iso'
rhcos_rootfs_image: 'rhcos-4.20.0-x86_64-live-rootfs.x86_64.img'
rhcos_live_image_url: "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.20/4.20.0/{{ rhcos_live_image }}"
rhcos_rootfs_image_url: "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.20/4.20.0/{{ rhcos_rootfs_image }}"
lab_url: "https://labs.sysdeseng.com/5g-ran-deployments-on-ocp-lab/{{ ocp4_major_release }}/index.html"
# yamllint enable rule:line-length
~~~

After:

~~~yaml
---
become_override: true
ocp_username: opentlc-mgr
silent: false
lab_version: "lab-4.21"
lab_release: "4.21"
repo_user: "RHsyseng"
platform_demo_redhat_com: true
student_name: "lab-user"
# yamllint disable rule:line-length
kcli_rpm: "https://github.com/{{ repo_user }}/5g-ran-deployments-on-ocp-lab/releases/download/{{ lab_release }}/kcli-99.0.0.git.202602040650.86cacd3-0.el9.x86_64.rpm"
lab_repo: "https://github.com/{{ repo_user }}/5g-ran-deployments-on-ocp-lab.git"
# yamllint enable rule:line-length
ocp4_major_release: "4.21"
ocp4_minor_release: "4.21.10"
lab_network_cidr: "192.168.125.0/24"
lab_network_domain: "5g-deployment.lab"
lab_sriov_domain: "sriov-network.lab"
lab_ptp_domain: "ptp-network.lab"
lab_sriov_cidr: "192.168.100.0/24"
lab_ptp_cidr: "192.168.200.0/24"
lab_registry_host: "infra.5g-deployment.lab:8443"
lab_api_host: "api.hub.5g-deployment.lab:6443"
upstream_dns: "1.1.1.1"
disconnected_update: false
download_rhcos_isos: false
install_lab_dependencies: false
hypervisor_min_memory_mb: 204800
# hypervisor_min_cpus: 128
hypervisor_min_cpus: 64
hypervisor_supported_distributions: ['RedHat', 'CentOS', 'Fedora']
lab_hub_vm_cpus: 16
lab_hub_vm_memory: 48000
lab_hub_vm_disk: 200
lab_sno_vm_cpus: 12
lab_sno_vm_memory: 24000
lab_sno_vm_disk: 200
extra_disk_libvirt_images: true
disconnected_catalog_image: infra.5g-deployment.lab:8443/redhat/redhat-operator-index:v4.21-1777899690
# yamllint disable rule:line-length
rhcos_live_image: 'rhcos-4.21.0-x86_64-live-iso.x86_64.iso'
rhcos_rootfs_image: 'rhcos-4.21.0-x86_64-live-rootfs.x86_64.img'
rhcos_live_image_url: "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.21/4.21.0/{{ rhcos_live_image }}"
rhcos_rootfs_image_url: "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.21/4.21.0/{{ rhcos_rootfs_image }}"
lab_url: "https://labs.sysdeseng.com/5g-ran-deployments-on-ocp-lab/{{ ocp4_major_release }}/index.html"
# yamllint enable rule:line-length
~~~