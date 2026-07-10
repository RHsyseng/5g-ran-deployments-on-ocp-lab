## Operation 2: End2End testing

This step has the following requirements:

- Lab has been deployed by the automation
- User has access to the hypervisor running the lab
- Passwordless ssh has been configured

Ask the user for the hypervisor hostname or IP and the user that has been configured in the hypervisor.

Once you have the information, try to access the hypervisor.

Operation **GOAL**: Make sure the instructions are accurate and all the steps work as intended. Take notes of what's different than expected (based on lab content). Make sure all URLs work and point to the relevant data.

**UNBREAKABLE RULES**:

- In the lab instructions there will be many references to `~/5g-deployment-lab/ztp-repository/` in these instructions you MUST NOT USE that path, instead use `/tmp/5g-deployment-lab-automation/ztp-repository/`.
- If instructions rely on WEBUI look for the CLI instructions, those WILL BE in the same instructions page.
- Follow steps ONE BY ONE, DO NOT RUSH through the steps.
- Stick to commands written in the docs. DO NOT INFER NEW COMMANDS.
- If building loops to watch current step process, make sure you add an early exit condition so the loop doesn't need to finish for you to move on to the next step.
- READ instructions, sometimes you can move to the next step and check back later the current one.
- If you find something not working as expected by given docs, STOP and ask the user what to do next (ABORT/TRY TO FIX IT).

**CRAFTING COMMANDS**:

You will be reading `.html` files. The files have instructions on the commands the user needs to run, you can detect command instructions by looking at the code like this:

Below code snippet is a command you need to run because it is contained within a '<code>' block and it has the 'data-lang' property set to 'bash'.

~~~html
<code class="language-bash hljs" data-lang="bash">mkdir -p ~/5g-deployment-lab/
git clone <a href="http://student:student@infra.5g-deployment.lab:3000/student/ztp-repository.git" class="bare">http://student:student@infra.5g-deployment.lab:3000/student/ztp-repository.git</a> ~/5g-deployment-lab/ztp-repository/</code>
~~~

Below code snippet is example output for the user to compare. We know it's example output because it has the 'data-lang' property set to 'console'.

~~~html
<code class="language-console hljs" data-lang="console">├── site-configs
│   ├── hub-1
│   │   ├── pre-reqs
│   │   │   └── sno-abi
</code>
~~~

**PROCEDURE**:

1. Make sure the testing folder doesn't exist and previous rhcos ibi iso is gone:

    ~~~sh
    rm -rf /tmp/5g-deployment-lab-automation/
    rm -f /opt/webcache/data/rhcos-ibi.iso
    ~~~

2. Create the repository that will be used by the Hub cluster to deploy the SNO

    ~~~sh
    # Create ztp-repository
    curl -X POST "http://infra.5g-deployment.lab:3000/api/v1/user/repos" -u "student:student" -H "Content-Type: application/json" -d '{"name": "ztp-repository","description": "ztp-repository","private": false,"auto_init": false}'
    ~~~

3. Check lab-content is created: `ls /opt/showroom/lab-content/`. You should get a folder with the lab version, for example '4.21'. You need to use this version in the following commands.

4. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/preparing-ztp-pipeline.html to initialize the repo structure.

5. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/preparing-ztp-pipeline.html to deploy the ZTP GitOps Pipeline. (If you need to hard refresh argocd apps you can use `oc annotate apps policies -n openshift-gitops argocd.argoproj.io/refresh=hard` with the hub kubeconfig)

6. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/crafting-cluster-telco-related-infra-operators-configs.html to initialize the policies.

7. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/installing-agentbasedinstall-cluster.html to deploy the abi sno. Wait for the deployment to finish before moving to the next task.

8. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/creating-seed-image.html to create the seed image. You must wait for it to finish before moving to the next task.

9. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/installing-imagebaseinstall-cluster.html to deploy the sno-ibi cluster. **IMPORTANT**: Make sure there is no a previous ISO from a previous run, make sure you move the old one so it's not used.

10. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/check-deployment-is-finished.html to check sno-ibi cluster is deployed. Infer the same steps to verify sno-abi is deployed as well. The two clusters MUST be installed before continuing with the next steps.

11. Follow the instructions in the file (hypervisor) /opt/showroom/lab-content/4.21/using-talm-to-update-clusters.html to run the IBU upgrades for sno-abi and sno-ibi. Wait for the update to complete and notify the user with your findings.
