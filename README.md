# Building Reliable Platforms on GCP with Google SRE

_Last tested on 11/03/2023 by @stevemcghee

<!-- ![image.png](./image.png) -->
<img src="img/arch52.png" width=70% height=70%>

_Figure: An Archetype: Global Anycast with regional isolated stacks and global database deployment model._

<img src="img/arch-diagram.png" width=70% height=70%>

_Figure: An Architecture: The same archetype as deployed on Google Cloud._


This is derived from the whitepaper: [Deployment Archetypes for Cloud Applcations](https://arxiv.org/pdf/2105.00560.pdf)

Also explained here: <https://cloud.google.com/architecture/deployment-archetypes>

See more from Ameer and Steve here:

[![Ameer and Steve talking at KubeconEU 2023](https://img.youtube.com/vi/OdLnC8sjPCI/0.jpg)](https://www.youtube.com/watch?v=OdLnC8sjPCI)


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

1. Kick off build.

   ```bash
   ./build.sh
   ```

1. View build in the Console.

   ```bash
   https://console.cloud.google.com/cloud-build
   ```

   > This step can take up to an hour to complete.

1. Connect to clusters.

   ```bash
   source infra/vars.sh
   # KCC and GKE Config
   gcloud anthos config controller get-credentials config-controller --location=${KCC_REGION} --project=${PROJECT_ID}
   kubectl config rename-context gke_${PROJECT_ID}_${KCC_REGION}_krmapihost-config-controller kcc
   gcloud container clusters get-credentials ${GKE_CONFIG_NAME} --zone ${GKE_CONFIG_LOCATION} --project ${PROJECT_ID}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_CONFIG_LOCATION}_${GKE_CONFIG_NAME} ${GKE_CONFIG_NAME}
   # GKE Dev
   gcloud container clusters get-credentials ${GKE_DEV1_NAME} --zone ${GKE_DEV1_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_DEV2_NAME} --zone ${GKE_DEV2_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_DEV3_NAME} --zone ${GKE_DEV3_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_DEV4_NAME} --zone ${GKE_DEV4_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_DEV5_NAME} --zone ${GKE_DEV5_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_DEV6_NAME} --zone ${GKE_DEV6_LOCATION} --project ${PROJECT_ID}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV1_LOCATION}_${GKE_DEV1_NAME} ${GKE_DEV1_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV2_LOCATION}_${GKE_DEV2_NAME} ${GKE_DEV2_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV3_LOCATION}_${GKE_DEV3_NAME} ${GKE_DEV3_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV4_LOCATION}_${GKE_DEV4_NAME} ${GKE_DEV4_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV5_LOCATION}_${GKE_DEV5_NAME} ${GKE_DEV5_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_DEV6_LOCATION}_${GKE_DEV6_NAME} ${GKE_DEV6_NAME}
   # GKE Prod
   gcloud container clusters get-credentials ${GKE_PROD1_NAME} --zone ${GKE_PROD1_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_PROD2_NAME} --zone ${GKE_PROD2_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_PROD3_NAME} --zone ${GKE_PROD3_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_PROD4_NAME} --zone ${GKE_PROD4_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_PROD5_NAME} --zone ${GKE_PROD5_LOCATION} --project ${PROJECT_ID}
   gcloud container clusters get-credentials ${GKE_PROD6_NAME} --zone ${GKE_PROD6_LOCATION} --project ${PROJECT_ID}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD1_LOCATION}_${GKE_PROD1_NAME} ${GKE_PROD1_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD2_LOCATION}_${GKE_PROD2_NAME} ${GKE_PROD2_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD3_LOCATION}_${GKE_PROD3_NAME} ${GKE_PROD3_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD4_LOCATION}_${GKE_PROD4_NAME} ${GKE_PROD4_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD5_LOCATION}_${GKE_PROD5_NAME} ${GKE_PROD5_NAME}
   kubectl config rename-context gke_${PROJECT_ID}_${GKE_PROD6_LOCATION}_${GKE_PROD6_NAME} ${GKE_PROD6_NAME}
   ```

1. Deploy `ops` repo.

   ```bash
   cd $HOME
   gcloud source repos clone ops --project=${PROJECT_ID}
   cd $HOME/ops
   git checkout -b main # Branch must be named main for Cloud Build to trigger
   cp -r ../Building-Reliable-Platforms-on-GCP-with-Google-SRE/ops/. .
   git add .
   git commit -am "Initial commit"
   git push --set-upstream origin main
   ```

1. Deploy `whereami`.

   ```bash
   cd $HOME
   gcloud source repos clone whereami --project=${PROJECT_ID}
   cd $HOME/whereami
   git checkout -b main # Branch must be named main for Cloud Build to trigger
   cp -r ../Building-Reliable-Platforms-on-GCP-with-Google-SRE/apps/whereami/. .
   git add .
   git commit -am "Initial commit"
   git push --set-upstream origin main
   ```

   After commiting, you can view the [Cloud Build pipeline](https://console.cloud.google.com/cloud-build).
   Cloud Build will build the image and eventually trigger the [Cloud Deploy pipeline](https://console.cloud.google.com/deploy).

1. Deploy `Cymbal Store`.

   ```bash
   cd $HOME
   gcloud source repos clone shop --project=${PROJECT_ID}
   cd $HOME/shop
   git checkout -b main # Branch must be named main for Cloud Build to trigger
   cp -r ../Building-Reliable-Platforms-on-GCP-with-Google-SRE/apps/shop/. .
   git add .
   git commit -am "Initial commit"
   git push --set-upstream origin main
   ```

   After commiting, you can view the [Cloud Build pipeline](https://console.cloud.google.com/cloud-build).
   Cloud Build will build the image and eventually trigger the [Cloud Deploy pipeline](https://console.cloud.google.com/deploy).

1. Deploy `Bank of Anthos`.

   ```bash
   cd $HOME
   gcloud source repos clone bank --project=${PROJECT_ID}
   cd $HOME/bank
   git checkout -b main # Branch must be named main for Cloud Build to trigger
   cp -r ../Building-Reliable-Platforms-on-GCP-with-Google-SRE/apps/bank/. .
   git add .
   git commit -am "Initial commit"
   git push --set-upstream origin main
   ```

   After commiting, you can view the [Cloud Build pipeline](https://console.cloud.google.com/cloud-build).
   Cloud Build will build the image and eventually trigger the [Cloud Deploy pipeline](https://console.cloud.google.com/deploy).

1. You can access your apps using the following URL patterns:
   * `https://{app_name}.endpoints.${project_name}.cloud.goog/`
     * eg: <https://whereami.endpoints.foo-bar-test.cloud.goog/>
