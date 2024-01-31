# Building Reliable Platforms on GCP with Google SRE

**NOTE: WIP**

_Last tested on 06/05/2023 by @ameer00_

<!-- ![image.png](./image.png) -->
<img src="./img/arch52.png" width=70% height=70%>

_Figure: Global Anycast with regional isolated stacks and global database deployment model._

[Deployment Archetypes for Cloud Applcations](https://arxiv.org/pdf/2105.00560.pdf)

## Getting started

1. Clone this repo.

   ```bash
   git clone https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git
   cd Building-Reliable-Platforms-on-GCP-with-Google-SRE
   ```
1. Checkout the *tf_in_repo_examples * branch

   ```bash
   git checkout tf_in_repo_examples 
   ```
**NOTE** If you want to change any of the infrastructure defaults used in this repo, please follow instructions in the **Deploy the platform infrastructure** section and return to the next step.

1. Define your GCP project ID.

   ```bash
   export PROJECT_ID=<YOUR PROJECT ID>
   ```

1. Kick off build with terraform

   ```bash
   ./build.sh --build terraform
   ```

1. View build in the Console.

   ```bash
   https://console.cloud.google.com/cloud-build
   ```

   > This step can take 20-30 minutes to complete.

### Deploy the platform infrastructure.
To deploy the platform infrastructure, you change some of the default values for the infrastructure deployment to suit the needs of your environment.
1. infra/terraform/vpc/variables.tf:
   1. The variable "fleets" defines the GKE subnet locations, name-prefixes, subnet cidrs. These values can be changed to suit your needs. The 6 GKE workload clusters will later be deployed in this vpc using the subnets created by this module.
   1. The variable "gke_config" defines the GKE subnet locations, name, subnet cidrs for the config clusters. These values can be changed to suit your needs. The GKE config cluster will later be deployed in this vpc using the subnets created by this module.

1. infra/terraform/gke/variables.tf: 
   1. The variable *kubernetes_version* is fixed at *1.27.3-gke.100*. This is the version that the repo is tested at. You can change this hard-coded version, but do not use *latest* as a value. This is because the clusters will be torn down and re-created by terraform if the *latest* version changes. 

### Deploy an application to the platform
This repo assumes that your application is made up of 1 or more services that may be owned by multiple teams.
This repo assumes that each of the services is stored either in their own repos or in different folders of the same repo. To make the use of this repo easier, try to follow this structure in your own application repos.

The structure assumed is as follows:
1. Application folder/repo
   1. Service-A repo/folder
      1. Application-repo/folder
         1. Source-code folder
         1. k8s folder
      1. Infra-repo/folder
         1. terraform folder
            1. Platform-infra folder
            1. Application-infra folder
            1. SLOs-infra folder
   1. Service-B repo/folder
      1. Application-repo/folder
         1. Source-code folder
         1. k8s folder
      1. Infra-repo/folder
         1. terraform folder
            1. Platform-infra folder
            1. Application-infra folder
            1. SLOs-infra folder
   1. ...

### Infra-repo
The infrastucture repo/folder will contain a terraform folder where all the terraform modules are stored.
1. The Platform-infra folder: Use this folder to create a terraform modules that will consume the following platform modules:
   1. deploy-pipeline: *Required*. You can use this module to define the archetype of the service along with the zones/regions where the service needs to be deployed. 
   1. artifact-registry: *Optional*, if you want an artifact registry to store container images of your service. 
   1. endpoints: *Optional*. If you want your service to have a public URL, this module will allow you to create an endpoint of the form **ENDPOINTNAME.endpoints.<PROJECT_ID>.cloud.goog**. This endpoint will resolve to the IP address of the loadbalancer that acts as a multi-cluster gateway

## Deploy an example application from this repo
Please read *examples/Examples.md* for more info on the structure of the examples.

### Deploy `nginx`.

The **nginx** application is a single service application which by default uses the *Active Passive Zone (APZ)* archetype. 
   ```bash
   
   cd $HOME
   ./deploy.sh --app nginx
   ```
   This will kick of a script that first creates the necessary infrastructure for the application using terraform. 
   The infrastructure created at this step are:
   1. GCP deployment pipelines
   1. Endpoints
   1. Artifact Registry (although unused in this application)
   1. and SLOs.

   The platform-terraform modules used in this step are found in the *modules* directory
   The GCP deployment pipelines select and configure the required GKE cluster targets based on the archetypes and the regions/zones specified. 
   After the creation of this basic infrastructure, the script then creates a new release on the *Cloud Deploy* pipeline the k8s manifests to the relevant GKE clusters.



### Deploy `whereami`.

The **whereami** application is a two-service application. Each service in the application may use a different archetype. In this example, by default the *whereami-frontend* uses the *Active Passive Region (APR)* archetype, and the *whereami-backend* uses the *Single Zone (SZ)* archetype.

   ```bash
   
   cd $HOME
   ./deploy.sh --app whereami
   ```
   This will kick of a script that first creates the necessary infrastructure for the two services using terraform. 
   The whereami frontend will be reachable at *http://whereami.endpoints.${PROJECT_ID}.cloud.goog/*
   
## Deploy an example application from an external repo


## Repo structure
The structure of the repository is meant to mimic the structure of a platform-team's repository. That is, it contains the automation and IaC for the GCP infrastucture that a platform team creates and manages. 
This example-repo only create one environment which is assumed to be the *production* environment.
While in production, one would want application teams to use their GCP project, this repo (atleast this version) uses a single GCP project.

This example multi-cluster setup uses GatewayAPI to define ingress rules and manage the Global loadbalancer. This example uses the Global Multi-cluster external gateway (gke-l7-global-external-managed-mc [class](https://cloud.google.com/kubernetes-engine/docs/how-to/gatewayclass-capabilities)). The clusters also use the Managed Anthos service mesh to manage traffic within and across clusters.
A total of 7 Autopilot GKE enterprise clusters are used in this setup. There are 6 clusters where workloads can be deployed, and 1 configuration cluster where the *gateway* resources and the *httproute* resources (for individual services) are deployed.

### Modules

The *modules* directory contains terraform modules for application teams to use in their application repos (applications are made up of 1 or more services)  to be able to deploy their application to this platform with each service using one of the archetypes. The intention is that the application teams use these terraform modules in their own CI/CD pipelines. They specify per service:
1. The Archetype for the service.
1. The Zone(s) in which the service will be deployed for zonal archetypes. OR
1. The Region(s) in which the service will be deployed for regional archetypes.


#### Artifact Registry
Creates an artifact registry to store images used for the application. It is expected that the CI pipeline will build and store images in the registry.

#### Deploy pipeline

Cloud deploy pipeline that: 
1. Deploys the *httproute* route for the workload in the *configuration* cluster.
1. Deploys the workload components (k8s manifests) to the required clusters based on the archetype selected.

#### Endpoint
External services use this module to create an external endpoint for users to their front-end services.

#### SLOs
*NOTE* There is currently a bug in GCP monitoring that prevents istio-canonical services from being auto imported into the monitoring SLOs dashboard. This prevents terraform from automatically finding the necessary canonical services when the SLOs terraform module is run. To prevent this error, first go to the GKE enterprise/ASM page and create a (any) SLO from it for each service. This makes the monitoring dashboard import the canonical service. You can delete the manually create SLO afterwards.

This module creates 2 SLOs per service deployed. 
1. A latency SLO with alerting policies. 
1. An availability SLO with alerting policies. 

## Bugs:
   - The K8s version needs to fixed in the buils/terraform/infra-create-gke.yaml. This is because using the *latest* version causes tf to teardown and recreate cluster everytime the default version changes.
      - Short-term fix: Not required. Just hardcode a K8s version in the file mentioned above.
   - ACM: ACM doesn't sometimes pick up all the clusters in the fleet. 
      - Short-term fix: Not known. Not easily reproducible.
   - CloudDeploy: Deployments sometimes fail the first time. This error usually occurs in the deployment validation phase when the pod is declared Unschedulable due to insufficient memory and cpu. This has likely to do with the interaction with Autopilot's autoscaling and really small starting size.
      - Short-term fix: Retrying the deployment(s) in cloud deploy console (click retry on the roll-out page) will fix it.
   - SLOs: SLOs cannot be created by tf until atleast one SLO is created for the service via console. This is because the canonical service cannot be found by cloud monitoring. This is a bug.
      - Short-term fix: Run the deploy  pipeline with the flag _DEPLOY_SLO_ONLY set to *false* in the ci pipeline for the shop service. After all the services in shop are deployed, create an (any) SLO manually for the service in the ASM section of the GKE console. And rerun the deploy pipeline with _DEPLOY_SLO_ONLY set to *true* in the ci pipeline for each service.
   - GKE teardown: When running the destruction pipeline (./build --terraform --destory), the GKE module fails at the end after the clusters are destroyed. This is because of a GKE hub "feature" that prevents destroy. Not sure which feature it is.

## TODO
1. Implement shop or bank
1. Implement https
1. Builds: Parameterize where possible. Clean up names.
1. deploy-pipelines: check why first deploy always fails.
1. terraform module deploy-pipelines: Use zone names and region names instead of indices
1. infra/asm: parameterise names of clusters in configsync annotation.

   