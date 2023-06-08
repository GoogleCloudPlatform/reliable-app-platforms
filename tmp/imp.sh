# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash

# Vars

export GKE1=gke1-r1a-prod
export GKE1_LOCATION=us-central1-a
export GKE2=gke2-r1b-prod
export GKE2_LOCATION=us-central1-b
export GKE3=gke3-r2a-prod
export GKE3_LOCATION=us-west2-a
export GKE4=gke4-r2b-prod
export GKE4_LOCATION=us-west2-b
export GKE5=gke5-config
export GKE5_LOCATION=us-west1-a
export KCC_REGION=us-central1


# Enable services

gcloud services enable \
      container.googleapis.com \
      krmapihosting.googleapis.com \
      cloudresourcemanager.googleapis.com \
      sourcerepo.googleapis.com \
      anthos.googleapis.com \
      gkehub.googleapis.com \
      multiclusteringress.googleapis.com \
      multiclusterservicediscovery.googleapis.com \
      trafficdirector.googleapis.com \
      mesh.googleapis.com \
      meshca.googleapis.com \
      --project=${PROJECT_ID}

# Create clusters

gcloud container clusters create $GKE1 \
    --zone=$GKE1_LOCATION \
    --enable-ip-alias \
    --min-nodes=3 \
    --max-nodes=8 \
    --scopes=cloud-platform \
    --machine-type=e2-standard-4 \
    --release-channel=regular \
    --maintenance-window-start=2000-01-01T07:00:00Z \
    --maintenance-window-end=2000-01-01T12:00:00Z \
    --maintenance-window-recurrence=FREQ=DAILY \
    --enable-network-policy \
    --enable-binauthz \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --cluster-version=1.22.8 \
    --project=$PROJECT_ID --async

gcloud container clusters create $GKE2 \
    --zone=$GKE2_LOCATION \
    --enable-ip-alias \
    --min-nodes=3 \
    --max-nodes=8 \
    --scopes=cloud-platform \
    --machine-type=e2-standard-4 \
    --release-channel=regular \
    --maintenance-window-start=2000-01-01T07:00:00Z \
    --maintenance-window-end=2000-01-01T12:00:00Z \
    --maintenance-window-recurrence=FREQ=DAILY \
    --enable-network-policy \
    --enable-binauthz \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --cluster-version=1.22.8 \
    --project=$PROJECT_ID --async

gcloud container clusters create $GKE3 \
    --zone=$GKE3_LOCATION \
    --enable-ip-alias \
    --min-nodes=3 \
    --max-nodes=8 \
    --scopes=cloud-platform \
    --machine-type=e2-standard-4 \
    --release-channel=regular \
    --maintenance-window-start=2000-01-01T07:00:00Z \
    --maintenance-window-end=2000-01-01T12:00:00Z \
    --maintenance-window-recurrence=FREQ=DAILY \
    --enable-network-policy \
    --enable-binauthz \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --cluster-version=1.22.8 \
    --project=$PROJECT_ID --async

gcloud container clusters create $GKE4 \
    --zone=$GKE4_LOCATION \
    --enable-ip-alias \
    --min-nodes=3 \
    --max-nodes=8 \
    --scopes=cloud-platform \
    --machine-type=e2-standard-4 \
    --release-channel=regular \
    --maintenance-window-start=2000-01-01T07:00:00Z \
    --maintenance-window-end=2000-01-01T12:00:00Z \
    --maintenance-window-recurrence=FREQ=DAILY \
    --enable-network-policy \
    --enable-binauthz \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --cluster-version=1.22.8 \
    --project=$PROJECT_ID --async

gcloud container clusters create $GKE5 \
    --zone=$GKE5_LOCATION \
    --enable-ip-alias \
    --min-nodes=3 \
    --max-nodes=8 \
    --scopes=cloud-platform \
    --machine-type=e2-standard-4 \
    --release-channel=regular \
    --maintenance-window-start=2000-01-01T07:00:00Z \
    --maintenance-window-end=2000-01-01T12:00:00Z \
    --maintenance-window-recurrence=FREQ=DAILY \
    --enable-network-policy \
    --enable-binauthz \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --cluster-version=1.22.8 \
    --project=$PROJECT_ID --async

# Confirm

gcloud container clusters list --project=$PROJECT_ID

# Gcloud auth stuff

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Kubeconfig

gcloud container clusters get-credentials ${GKE1} --zone ${GKE1_LOCATION} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${GKE2} --zone ${GKE2_LOCATION} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${GKE3} --zone ${GKE3_LOCATION} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${GKE4} --zone ${GKE4_LOCATION} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${GKE5} --zone ${GKE5_LOCATION} --project ${PROJECT_ID}
kubectl config rename-context gke_${PROJECT_ID}_${GKE1_LOCATION}_${GKE1} ${GKE1}
kubectl config rename-context gke_${PROJECT_ID}_${GKE2_LOCATION}_${GKE2} ${GKE2}
kubectl config rename-context gke_${PROJECT_ID}_${GKE3_LOCATION}_${GKE3} ${GKE3}
kubectl config rename-context gke_${PROJECT_ID}_${GKE4_LOCATION}_${GKE4} ${GKE4}
kubectl config rename-context gke_${PROJECT_ID}_${GKE5_LOCATION}_${GKE5} ${GKE5}


# Register clusters

gcloud container fleet memberships register gke1-hub-membership \
     --gke-cluster $GKE1_LOCATION/$GKE1 \
     --enable-workload-identity \
     --project=$PROJECT_ID

gcloud container fleet memberships register gke2-hub-membership \
     --gke-cluster $GKE2_LOCATION/$GKE2 \
     --enable-workload-identity \
     --project=$PROJECT_ID

gcloud container fleet memberships register gke3-hub-membership \
     --gke-cluster $GKE3_LOCATION/$GKE3 \
     --enable-workload-identity \
     --project=$PROJECT_ID

gcloud container fleet memberships register gke4-hub-membership \
     --gke-cluster $GKE4_LOCATION/$GKE4 \
     --enable-workload-identity \
     --project=$PROJECT_ID

gcloud container fleet memberships register gke5-hub-membership \
     --gke-cluster $GKE5_LOCATION/$GKE5 \
     --enable-workload-identity \
     --project=$PROJECT_ID

# Confirm fleet registration

gcloud container fleet memberships list --project=$PROJECT_ID

# Enable MCS

gcloud container fleet multi-cluster-services enable \
    --project $PROJECT_ID

# IAM for MCS

 gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member "serviceAccount:$PROJECT_ID.svc.id.goog[gke-mcs/gke-mcs-importer]" \
     --role "roles/compute.networkViewer" \
     --project=$PROJECT_ID

# Confirm MCS for all clusters

gcloud container fleet multi-cluster-services describe --project=$PROJECT_ID

# Gateway CRDs

kubectl --context=$GKE5 apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.3"

# kubectl --context=$GKE5 delete -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.3"

# Enable MCG Controller

gcloud container fleet ingress enable \
    --config-membership=/projects/$PROJECT_ID/locations/global/memberships/gke5-hub-membership \
    --project=$PROJECT_ID

# gcloud container fleet ingress disable

# Confirm MCG

gcloud container fleet ingress describe --project=$PROJECT_ID

# IAM for MCG

export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')
echo -e "PROJECT_NUMBER is ${PROJECT_NUMBER}"
 gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member "serviceAccount:service-$PROJECT_NUMBER@gcp-sa-multiclusteringress.iam.gserviceaccount.com" \
     --role "roles/container.admin" \
     --project=$PROJECT_ID

 gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member "serviceAccount:service-$PROJECT_NUMBER@gcp-sa-multiclusteringress.iam.gserviceaccount.com" \
     --role "roles/serviceusage.serviceUsageConsumer" \
     --project=$PROJECT_ID

# Confirm Gatewayclasses

kubectl --context=$GKE5 get gatewayclasses

# Create config repo

gcloud source repos create config --project=$PROJECT_ID

# Enable ACM

gcloud beta container hub config-management enable --project=$PROJECT_ID

# Config sync SA

gcloud iam service-accounts create config-sync-sa --project=$PROJECT_ID

gcloud iam service-accounts add-iam-policy-binding \
   --role roles/iam.workloadIdentityUser \
   --member "serviceAccount:$PROJECT_ID.svc.id.goog[config-management-system/config-sync-sa]" \
   config-sync-sa@$PROJECT_ID.iam.gserviceaccount.com

 gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member "serviceAccount:config-sync-sa@$PROJECT_ID.iam.gserviceaccount.com" \
     --role "roles/source.reader" \
     --project=$PROJECT_ID

# ACM install

cat <<EOF > apply-spec.yaml 
applySpecVersion: 1
spec:
  configSync:
    # Set to true to install and enable Config Sync
    enabled: true
    # If you don't have a Git repository, omit the following fields. You
    # can configure them later.
    sourceFormat: unstructured
    syncRepo: https://source.developers.google.com/p/$PROJECT_ID/r/config
    syncBranch: master
    secretType: gcpserviceaccount
    gcpServiceAccountEmail: config-sync-sa@$PROJECT_ID.iam.gserviceaccount.com
    preventDrift: true
  policyController:
    enabled: true
    referentialRulesEnabled: true
    auditIntervalSeconds: 15
    logDeniesEnabled: true
EOF

gcloud beta container hub config-management apply \
        --membership=gke1-hub-membership \
        --config=apply-spec.yaml \
        --project=${PROJECT_ID}

gcloud beta container hub config-management apply \
        --membership=gke2-hub-membership \
        --config=apply-spec.yaml \
        --project=${PROJECT_ID}

gcloud beta container hub config-management apply \
        --membership=gke3-hub-membership \
        --config=apply-spec.yaml \
        --project=${PROJECT_ID}

gcloud beta container hub config-management apply \
        --membership=gke4-hub-membership \
        --config=apply-spec.yaml \
        --project=${PROJECT_ID}

# Additional ACM IAM step

gcloud iam service-accounts add-iam-policy-binding \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:$PROJECT_ID.svc.id.goog[config-management-system/root-reconciler]" \
config-sync-sa@$PROJECT_ID.iam.gserviceaccount.com

# Enable Mesh feature

gcloud container fleet mesh enable --project ${PROJECT_ID}

# Deploy ASM

gcloud container fleet mesh update \
        --control-plane automatic \
        --memberships gke1-hub-membership \
        --project ${PROJECT_ID}

gcloud container fleet mesh update \
        --control-plane automatic \
        --memberships gke2-hub-membership \
        --project ${PROJECT_ID}

gcloud container fleet mesh update \
        --control-plane automatic \
        --memberships gke3-hub-membership \
        --project ${PROJECT_ID}

gcloud container fleet mesh update \
        --control-plane automatic \
        --memberships gke4-hub-membership \
        --project ${PROJECT_ID}

# Verify ASM

gcloud container fleet mesh describe --project ${PROJECT_ID}

# ASM Multicluster

kubectl --context=${GKE1} patch configmap/asm-options -n istio-system --type merge -p '{"data":{"multicluster_mode":"connected"}}'
      kubectl --context=${GKE2} patch configmap/asm-options -n istio-system --type merge -p '{"data":{"multicluster_mode":"connected"}}'
      kubectl --context=${GKE3} patch configmap/asm-options -n istio-system --type merge -p '{"data":{"multicluster_mode":"connected"}}'
      kubectl --context=${GKE4} patch configmap/asm-options -n istio-system --type merge -p '{"data":{"multicluster_mode":"connected"}}'

# ASM Telemetry

cat <<EOF > asm-telemetry.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: istio-asm-managed
  namespace: istio-system
data:
  mesh: |-
    accessLogFile: /dev/stdout
    defaultConfig:
      tracing:
        stackdriver:{}
EOF

kubectl --context=${GKE1} apply -f asm-telemetry.yaml
kubectl --context=${GKE2} apply -f asm-telemetry.yaml
kubectl --context=${GKE3} apply -f asm-telemetry.yaml
kubectl --context=${GKE4} apply -f asm-telemetry.yaml

# ASM gateways

cat <<EOF > asm-gateways.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: asm-gateways
  labels:
    istio.io/rev: asm-managed
---
apiVersion: v1
kind: Service
metadata:
  name: asm-ingressgateway
  namespace: asm-gateways
  labels:
    app: asm-ingressgateway
    asm: ingressgateway
spec:
  type: LoadBalancer
  selector:
    asm: ingressgateway
  ports:
  - port: 80
    name: http
  - port: 443
    name: https
---
kind: ServiceExport
apiVersion: net.gke.io/v1
metadata:
  name: asm-ingressgateway
  namespace: asm-gateways
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: asm-ingressgateway
  namespace: asm-gateways
  labels:
    app: asm-ingressgateway
    asm: ingressgateway
spec:
  selector:
    matchLabels:
      app: asm-ingressgateway
      asm: ingressgateway
  template:
    metadata:
      annotations:
        # This is required to tell Anthos Service Mesh to inject the gateway with the
        # required configuration.
        inject.istio.io/templates: gateway
      labels:
        app: asm-ingressgateway
        asm: ingressgateway
    spec:
      containers:
      - name: istio-proxy
        image: auto # The image will automatically update each time the pod starts.
---
apiVersion: v1
kind: Service
metadata:
  name: asm-egressgateway
  namespace: asm-gateways
  labels:
    app: asm-egressgateway
    asm: egressgateway
spec:
  type: LoadBalancer
  selector:
    asm: egressgateway
  ports:
  - port: 80
    name: http
  - port: 443
    name: https
---
kind: ServiceExport
apiVersion: net.gke.io/v1
metadata:
  name: asm-egressgateway
  namespace: asm-gateways
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: asm-egressgateway
  namespace: asm-gateways
  labels:
    app: asm-egressgateway
    asm: egressgateway
spec:
  selector:
    matchLabels:
      app: asm-egressgateway
      asm: egressgateway
  template:
    metadata:
      annotations:
        # This is required to tell Anthos Service Mesh to inject the gateway with the
        # required configuration.
        inject.istio.io/templates: gateway
      labels:
        app: asm-egressgateway
        asm: egressgateway
    spec:
      containers:
      - name: istio-proxy
        image: auto # The image will automatically update each time the pod starts.
---
apiVersion: v1
kind: Service
metadata:
  name: asm-eastwestgateway
  namespace: asm-gateways
  labels:
    app: asm-eastwestgateway
    asm: eastwestgateway
    topology.istio.io/network: default
spec:
  type: LoadBalancer
  selector:
    asm: eastwestgateway
  ports:
  - port: 15021
    name: status-port
    targetPort: 15021
  - port: 15443
    name: tls
    targetPort: 15443
---
kind: ServiceExport
apiVersion: net.gke.io/v1
metadata:
  name: asm-eastwestgateway
  namespace: asm-gateways      
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: asm-eastwestgateway
  namespace: asm-gateways
  labels:
    app: asm-eastwestgateway
    asm: eastwestgateway
spec:
  selector:
    matchLabels:
      app: asm-eastwestgateway
      asm: eastwestgateway
  template:
    metadata:
      annotations:
        # This is required to tell Anthos Service Mesh to inject the gateway with the
        # required configuration.
        inject.istio.io/templates: gateway
      labels:
        app: asm-eastwestgateway
        asm: eastwestgateway
        topology.istio.io/network: default
    spec:
      containers:
      - name: istio-proxy
        image: auto # The image will automatically update each time the pod starts.
        env:
        # traffic through this gateway should be routed inside the network
        - name: ISTIO_META_REQUESTED_NETWORK_VIEW
          value: default
        - name: ISTIO_META_ROUTER_MODE
          value: sni-dnat
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: asm-gateways-sds
  namespace: asm-gateways
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: asm-gateways-sds
  namespace: asm-gateways
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: asm-gateways-sds
subjects:
- kind: ServiceAccount
  name: default
EOF

gcloud source repos clone config --project=${PROJECT_ID}
mkdir -p config/asm
cp -r asm-gateways.yaml config/asm
cd config
git add . && git commit -am "Deploy ASM gateways"
git push

# Nomos status

nomos status

