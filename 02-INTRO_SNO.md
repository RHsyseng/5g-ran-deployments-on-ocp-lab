#1 Introduction to Single Node OpenShift (SNO)

Edge computing is everywhere. While many organizations look to take advantage of deploying applications at the edge, the physical nature of many of these edge sites can cause challenges to the architects who need to deploy hardware in confined spaces or where network connectivity back to the central data center may be intermittent. To help solve this problem, we have been working to make our Red Hat OpenShift footprint smaller to fit into these more constrained environments by putting both control and worker capabilities into a single node. As of OpenShift 4.9, we now have a full OpenShift deployment in a single node.

This is a perfect use case that it is seen in telecommunication service providers' implementation of a Radio Access Network (RAN) as part of a 5G mobile network.
In the context of telecommunications service providers' 5G RANs, it is increasingly common to see "cloud native" implementations of the 5G Distributed Unit (DU) components. Due to latency constraints, the DU needs to be deployed very close to the Radio Units (RUs), for which it is responsible. In practice, this can mean running the DU on anything from a single server at the base of a cell tower to a more datacenter-like environment serving several RUs.

A typical DU example is a resource-intensive workload, requiring 6 dedicated cores per DU and several DUs packed on the server, with 16-24 GB of RAM per DU (consumed as huge pages), multiple single route I/O virtualization (SR-IOV) NICs, FPGA, or GPU acceleration cards  carrying several Gbps of traffic each.

One crucial detail of this use case is ensuring that this workload can be "autonomous" so that it can continue operating with its existing configuration, even when any centralized management functionality is unavailable. This is where single node OpenShift comes in.



Single node OpenShift offers both control and worker node capabilities in a single server and provides users with a consistent experience across the sites where OpenShift is deployed, regardless of the size of the deployment. Keep in mind a single node OpenShift deployment differs from the default self-managed/highly-available cluster profile in couple of ways:

* To optimize system resource usage, many operators are configured to reduce the footprint of their operands when running on a single node OpenShift.
* In environments that require high availability, it is recommended that the architecture be configured in a way in which if the hardware was to fail, those workloads are transitioned to other sites or nodes while the impacted node is recovered. 

You can create a single-node cluster with standard installation methods. OpenShift Container Platform on a single node is a specialized installation that requires the creation of a special ignition configuration ISO. The primary use case is for edge computing workloads, including intermittent connectivity, portable clouds, and 5G radio access networks (RAN) close to a base station. The major tradeoff with an installation on a single node is the lack of high availability.

The use of OpenShiftSDN with single-node OpenShift is not supported. OVN-Kubernetes is the default networking solution for single-node OpenShift deployments.

Single-node OpenShift requires the following minimum host resources: vCPU: 8, VirtualRAM: 16 GB, Storage: 120 GB 
Single-node OpenShift deployment does not have an option to add additional hosts. 
Single-node OpenShift isn’t highly-available. It explicitly does not assume zero downtime of the Kubernetes API.


Installing OpenShift Container Platform on a single node is supported on bare metal, vSphere, Red Hat OpenStack, and Red Hat Virtualization platforms

Profile	vCPU	Memory	Storage
Minimum

8 vCPU cores

16GB of RAM

120GB

 The server must have access to the internet or access to a local registry if it is not connected to a routable network. The server must have a DHCP reservation or a static IP address for the Kubernetes API, ingress route, and cluster node domain names. You must configure the DNS to resolve the IP address to each of the following fully qualified domain names (FQDN)

OpenShift installs typically require a temporary bootstrap machine, which is usually a separate machine, but edge deployments are often performed in environments where there are no extra nodes. However, for these use-cases, the new functionality provided by OpenShift’s “Bootstrap-in-Place” option eliminates the separate bootstrap node requirement for single-node deployments. So when installing single-node OpenShift, you only need the node you wish to install onto.

With single-node OpenShift, you have three choices to perform the installation:

Red Hat Advanced Cluster Management for Kubernetes - allows provisioning single-node OpenShift using kube-native APIs. Read more about it here.  
 You can install single-node OpenShift using the web-based Assisted Installer and a discovery ISO that you generate using the Assisted Installer. You can also install single-node OpenShift by using coreos-installer to generate the installation ISO.

https://docs.openshift.com/container-platform/4.11/installing/installing_sno/install-sno-installing-sno.html#install-booting-from-an-iso-over-http-redfish_install-sno-installing-sno-with-the-assisted-installer