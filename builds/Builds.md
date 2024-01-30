Infra-create-gcs.yaml
Infra-enable-apis.yaml
Infra-create-repos.yaml
Infra-create-vpc.yaml
Infra-create-gke.yaml
Infra-features-gke-prod-mesh-confirm.yaml 
    Checks all clusters are running 
    Checks mesh membership for all clusters
Infra-features-gke-prod-mesh-config.yaml
    Checks all clusters are running
    Sets up multicluster mesh (Patch config)
Infra-features-gke-mesh-gateways.yaml
    Step: Infra-features-create-workload-identity-asm: Install workload identity for the service account for the root sync repo.
    Step: Infra-features-gke-mesh-gateways: Pushes ASM + Gateway config to ACM repo
Infra-features-gke-mesh-gateways-prod.yaml
    Checks all clusters are running
    Checks nomos status
    Checks ASM ingress gateway status to be running
Infra-features-gke-gateway.yaml
    Step: Infra-features-gke-gateway-config-cluster: Sets the config cluster value
    Step: Infra-features-gke-get-gateway-address: Uploads GKE Gateway IP address to storage account.
Infra-sa-gke-mci-roles.yaml: Gives necessary roles to MulticlusterIngress SA.
