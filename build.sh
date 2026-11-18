#!/usr/bin/env bash
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

# Verify that the scripts are being run from Linux and not Mac
if [[ $OSTYPE != "linux-gnu" ]]; then
    echo -e "\e[91mERROR: This script has only been tested on Linux. Currently, only Linux (debian) is supported. Please run in Cloud Shell or in a VM running Linux".
    exit;
fi

# Export a SCRIPT_DIR var and make all links relative to SCRIPT_DIR
export SCRIPT_DIR=$(dirname $(readlink -f $0 2>/dev/null) 2>/dev/null || echo "${PWD}/$(dirname $0)")

usage()
{
   echo ""
   echo "Usage: $0"
   echo -e "\tExample usage: /build.sh"
   exit 1 # Exit script after printing help
}

terraform_destroy()
{
    echo -e "\e[95mSetting DESTROY var to 'true'...\e[0m"
    DESTROY=true
}

# Setting default value
unset DESTROY
unset KUBE_VERSION
# Define bash args
while [ "$1" != "" ]; do
    case $1 in
        --destroy | -d )      shift
                                terraform_destroy
                                ;;
        --help | -h )           usage
                                exit
                                ;;
        --k8s)                  shift
                                KUBE_VERSION=$1
                                ;;
        
    esac
    shift
done

# Set project to PROJECT_ID or exit
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR PROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
gcloud config set core/project ${PROJECT_ID}

# Enable Cloudbuild and IAM APIs
echo -e "\e[95mEnabling Cloudbuild and IAM APIs in ${PROJECT_ID}\e[0m"
gcloud services enable cloudbuild.googleapis.com storage.googleapis.com serviceusage.googleapis.com cloudresourcemanager.googleapis.com iam.googleapis.com

# Create dedicated platform builder service account with least-privilege platform roles
PLATFORM_SA_NAME="rap-platform-builder"
PLATFORM_SA_EMAIL="${PLATFORM_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
PLATFORM_SA_RESOURCE="projects/${PROJECT_ID}/serviceAccounts/${PLATFORM_SA_EMAIL}"

echo -e "\e[95mConfiguring dedicated Cloud Build service account ${PLATFORM_SA_EMAIL} in ${PROJECT_ID}\e[0m"
if ! gcloud iam service-accounts describe "${PLATFORM_SA_EMAIL}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  gcloud iam service-accounts create "${PLATFORM_SA_NAME}" \
    --project="${PROJECT_ID}" \
    --display-name="Reliable App Platforms Builder"
fi

PLATFORM_ROLES=(
  "roles/logging.logWriter"
  "roles/cloudbuild.builds.editor"
  "roles/storage.admin"
  "roles/serviceusage.serviceUsageAdmin"
  "roles/serviceusage.apiKeysAdmin"
  "roles/source.admin"
  "roles/compute.networkAdmin"
  "roles/compute.securityAdmin"
  "roles/container.admin"
  "roles/gkehub.admin"
  "roles/iam.serviceAccountAdmin"
  "roles/iam.serviceAccountUser"
  "roles/resourcemanager.projectIamAdmin"
  "roles/artifactregistry.admin"
  "roles/clouddeploy.admin"
  "roles/servicemanagement.admin"
  "roles/monitoring.admin"
  "roles/secretmanager.admin"
)
for role in "${PLATFORM_ROLES[@]}"; do
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${PLATFORM_SA_EMAIL}" \
    --role="${role}" \
    --condition=None \
    --quiet >/dev/null
done

# Start main build
[[ "${DESTROY}" != "true" ]] &&  echo -e "\e[95mStarting Cloudbuild to CREATE infrastructure using terraform...\e[0m"
[[ "${DESTROY}" == "true" ]] &&  echo -e "\e[95mStarting Cloudbuild to DELETE infrastructure using terraform...\e[0m"

[[ "${DESTROY}" != "true" ]] && gcloud builds submit --config=builds/infra_terraform.yaml --service-account="${PLATFORM_SA_RESOURCE}" --substitutions=_PROJECT_ID=${PROJECT_ID},_KUBE_VERSION=${K8SVERSION} --async
[[ "${DESTROY}" == "true" ]] && gcloud builds submit --config=builds/infra_terraform_destroy.yaml --service-account="${PLATFORM_SA_RESOURCE}" --substitutions=_PROJECT_ID=${PROJECT_ID} --async
echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
