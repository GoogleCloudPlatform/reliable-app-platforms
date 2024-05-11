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
BUILD=terraform

# Define bash args
while [ "$1" != "" ]; do
    case $1 in
        --destroy | -d )      shift
                                terraform_destroy
                                ;;
        --help | -h )           usage
                                exit
    esac
    shift
done

# Set project to PROJECT_ID or exit
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR PROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
gcloud config set core/project ${PROJECT_ID}

# Enable Cloudbuild API
echo -e "\e[95mEnabling Cloudbuild API in ${PROJECT_ID}\e[0m"
gcloud services enable cloudbuild.googleapis.com storage.googleapis.com serviceusage.googleapis.com cloudresourcemanager.googleapis.com

# Make cloudbiuld SA roles/owner for PROJECT_ID
# TODO: Make these permissions more granular to precisely what is required by cloudbuild
echo -e "\e[95mAssigning Cloudbuild Service Account roles/owner in ${PROJECT_ID}\e[0m"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com --role roles/owner

# Start main build
[[ "${DESTROY}" != "true" ]] &&  echo -e "\e[95mStarting Cloudbuild to CREATE infrastructure using ${BUILD}...\e[0m"
[[ "${DESTROY}" == "true" ]] &&  echo -e "\e[95mStarting Cloudbuild to DELETE infrastructure using ${BUILD}...\e[0m"

[[ "${BUILD}" == "terraform" ]] && [[ "${DESTROY}" != "true" ]] && gcloud builds submit --config=builds/infra_terraform.yaml --substitutions=_PROJECT_ID=${PROJECT_ID} --async
[[ "${BUILD}" == "terraform" ]] && [[ "${DESTROY}" == "true" ]] && gcloud builds submit --config=builds/infra_terraform_destroy.yaml --substitutions=_PROJECT_ID=${PROJECT_ID} --async
echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
