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

   