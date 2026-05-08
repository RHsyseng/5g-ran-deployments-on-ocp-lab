
# THIS IS WIP, WE WANT TO PROVIDE DETERMINISTIC SCRIPTS FOR EACH LAB SECTION AND HAVE THE AGENT RUN THEM

## Operation 2: End2End testing

This step has the following requirements:

- Lab has been deployed by the automation
- User has access to the hypervisor running the lab
- Passwordless ssh has been configured

Ask the user for the hypervisor hostname or IP and the user that has been configured in the hypervisor.

Once you have the information, try to access the hypervisor.

Operation **GOAL**: Make sure the instructions are accurate and all the steps work as intended. Take notes of what's different than expected (based on lab content). Make sure all URLs work and point to the relevant data.

**IMPORTANT**: In the lab instructions there will be many references to `~/5g-deployment-lab/ztp-repository/` in these instructions you MUST NOT USE that path, instead use `/tmp/ibu-seed-image-gen/ztp-repository/`. If instructions rely on WEBUI look for the CLI instructions, those WILL BE in the same instructions page. DO STEP BY STEP, DO NOT TRY TO READ MULTIPLE INSTRUCTIONS BEFOREHAND. Make sure when waiting for commands you have breaks into the loops to avoid waiting for the fixed ammount of time you defined.

1. Create the repository that will be used by the Hub cluster to deploy the SNO

    ~~~sh
    # Create ztp-repository
    curl -X POST "http://infra.5g-deployment.lab:3000/api/v1/user/repos" -u "student:student" -H "Content-Type: application/json" -d '{"name": "ztp-repository","description": "ztp-repository","private": false,"auto_init": false}'
    ~~~

2. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/preparing-ztp-pipeline.html to initialize the repo structure.

3. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/preparing-ztp-pipeline.html to deploy the ZTP GitOps Pipeline. (If you need to hard refresh argocd apps you can use `oc annotate apps policies -n openshift-gitops argocd.argoproj.io/refresh=hard` with the hub kubeconfig)

4. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/crafting-cluster-telco-related-infra-operators-configs.html to initialize the policies.

5. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/installing-agentbasedinstall-cluster.html to deploy the abi sno that will be used to build the seed image. **NOTE**: You can move to the next point, you will check if this finished on step 8.

6. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/creating-seed-image.html to create the seed image. You must wait for it to finish before moving to the next task.

7. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/installing-imagebaseinstall-cluster.html to deploy the sno-ibi cluster. **IMPORTANT**: Make sure there is no a previous ISO from a previous run, make sure you move the old one so it's not used.

8. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/check-deployment-is-finished.html to check sno-ibi cluster is deployed. Infer the same steps to verify sno-abi is deployed as well. The two clusters MUST be installed before continuing with the next steps.

9. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/using-talm-to-update-clusters.html to run the IBU upgrades for sno-abi and sno-ibi. Wait for the update to complete and notify the user with your findings.