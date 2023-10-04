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
   echo -e "\t--app | -a Must be one of 'whereami' or 'bank', or 'shop'. Default is 'whereami'."
   echo -e "\tExample usage:"op
   echo -e "\t./deploy.sh -a whereami"
   exit 1 # Exit script after printing help
}



# Setting default value
APPLICATION=whereami

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

# Set project to PROJECT_ID or exit
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR POROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
echo -e "\e[95mAPPLICATION is set to ${APPLICATION}\e[0m"

gcloud config set core/project ${PROJECT_ID}

# Enable Cloudbuild API

 gcloud builds submit --config=builds/cloudbuild/cloudbuild_whereami.yaml --substitutions=_PROJECT_ID=${PROJECT_ID} --async
# echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
