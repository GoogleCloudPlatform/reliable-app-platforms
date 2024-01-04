# Building Reliable Platforms on GCP with Google SRE

NOT up-to-date WIP

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
1. Checkout the *tf* branch

   ```bash
   git checkout tf
   ```

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

## Deploy an example application from this repo
Please read *examples/Examples.md* for more info on the structure of the examples.

### Deploy `nginx`.

The **nginx** application is a single service application which by default uses the *Active Passive Zone (APZ)* archetype. 
   ```bash
   
   cd $HOME/examples
   ./deploy.sh --app=nginx
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

**WIP: Incomplete**

The **whereami** application is a two-service application. Each service in the application may use a different archetype. In this example, by default the *whereami-frontend* uses the *Active Passive Region (APR)* archetype, and the *whereami-backend* uses the *Single Zone (SZ)* archetype.

   ```bash
   
   cd $HOME/examples
   ./deploy.sh --app=whereami
   ```
   This will kick of a script that first creates the necessary infrastructure for the two services using terraform. 
   
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
WIP



   