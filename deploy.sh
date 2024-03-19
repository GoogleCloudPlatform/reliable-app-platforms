#!/usr/bin/env bash

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
   echo -e "\t--app | -a Must be one of 'nginx' or 'whereami', or 'shop'. Default is 'nginx'."
   echo -e "\tExample usage:"op
   echo -e "\t./deploy.sh -a nginx"
   exit 1 # Exit script after printing help
}

# Setting default value
APPLICATION=nginx

# Define bash args
while [ "$1" != "" ]; do
    case $1 in
        --app | -a )        shift
                                APPLICATION=$1
                                ;;
        --help | -h )           usage
                                exit
    esac
    shift
done

# Create a short SHA until this is tied to a git repo and can use a commit sha
while true; do
    SHORT_SHA=$(head -c 64 /dev/urandom | tr -dc 'a-z0-9-' | grep -E '^[a-z]' | head -n 1 | cut -c1-63)
    if [[ -n $SHORT_SHA ]]; then  # Check if SHORT_SHA is not empty
        break
    fi
done

# Set project to PROJECT_ID or exit
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR POROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
echo -e "\e[95mAPPLICATION is set to ${APPLICATION}\e[0m"
echo -e "\e[95mSHORT_SHA is set to ${SHORT_SHA}\e[0m"

gcloud config set core/project ${PROJECT_ID}
[[ ${APPLICATION} == "nginx" ]] && echo -e "\e[95mStarting to deploy application ${APPLICATION}...\e[0m" && gcloud builds submit --config=examples/nginx/ci.yaml --substitutions=_PROJECT_ID=${PROJECT_ID},_SHORT_SHA=${SHORT_SHA}  --async
[[ ${APPLICATION} == "whereami" ]] && echo -e "\e[95mStarting to deploy application ${APPLICATION}...\e[0m" && gcloud builds submit --config=examples/whereami/ci.yaml --substitutions=_PROJECT_ID=${PROJECT_ID},_SHORT_SHA=${SHORT_SHA}  --async
[[ ${APPLICATION} == "shop" ]] && echo -e "\e[95mStarting to deploy application ${APPLICATION}...\e[0m" && gcloud builds submit --config=examples/shop/ci.yaml --substitutions=_PROJECT_ID=${PROJECT_ID},_SHORT_SHA=${SHORT_SHA}  --async
echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
