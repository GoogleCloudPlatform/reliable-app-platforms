#!/usr/bin/env bash

# Export a SCRIPT_DIR var and make all links relative to SCRIPT_DIR
export SCRIPT_DIR=$(dirname $(readlink -f $0 2>/dev/null) 2>/dev/null || echo "${PWD}/$(dirname $0)")

usage()
{
   echo ""
   echo "Usage: $0"
   echo -e "\t--app | -a Must be one of 'nginx'." 
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
[[ ! "${GITHUB_USER}" ]] && echo -e "Please export GITHUB_USER variable (\e[95mexport GITHUB_USER=<YOUR GITHUB_USER>\e[0m)\nExiting." && exit 0
[[ ! "${GITHUB_EMAIL}" ]] && echo -e "Please export GITHUB_EMAIL variable (\e[95mexport GITHUB_EMAIL=<YOUR GITHUB_EMAIL>\e[0m)\nExiting." && exit 0
[[ ! "${GITHUB_TOKEN}" ]] && echo -e "Please export GITHUB_TOKEN variable (\e[95mexport GITHUB_TOKEN=<YOUR GITHUB_TOKEN>\e[0m)\nExiting." && exit 0
[[ ! "${GITHUB_ORG}" ]] && echo -e "Please export GITHUB_ORG variable (\e[95mexport GITHUB_ORG=<YOUR GITHUB_ORG>\e[0m)\nExiting." && exit 0
[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR PROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
echo -e "\e[95mGITHUB_USER is set to ${GITHUB_USER}\e[0m"
echo -e "\e[95mGITHUB_EMAIL is set to ${GITHUB_EMAIL}\e[0m"
echo -e "\e[95mGITHUB_TOKEN is set to *REDACTED*\e[0m"
echo -e "\e[95mGITHUB_ORG is set to ${GITHUB_ORG}\e[0m"
echo -e "\e[95mAPPLICATION is set to ${APPLICATION}\e[0m"
echo -e "\e[95mSHORT_SHA is set to ${SHORT_SHA}\e[0m"

gcloud config set core/project ${PROJECT_ID}
gcloud services enable secretmanager.googleapis.com apikeys.googleapis.com && sleep 30

USER_SECRET=$(gcloud secrets describe github-user --format=json --verbosity=error 2>/dev/null | jq 'has("name")')
if [[ ${USER_SECRET} != "true" ]]; then
    printf ${GITHUB_USER} | gcloud secrets create github-user --data-file=- > /dev/null
fi
EMAIL_SECRET=$(gcloud secrets describe github-email --format=json --verbosity=error 2>/dev/null | jq 'has("name")')
if [[ ${EMAIL_SECRET} != "true" ]]; then
    printf ${GITHUB_EMAIL} | gcloud secrets create github-email --data-file=- > /dev/null
fi
TOKEN_SECRET=$(gcloud secrets describe github-token --format=json --verbosity=error 2>/dev/null| jq 'has("name")')
if [[ ${TOKEN_SECRET} != "true" ]]; then
    printf ${GITHUB_TOKEN} | gcloud secrets create github-token --data-file=- > /dev/null
fi
ORG_SECRET=$(gcloud secrets describe github-org --format=json --verbosity=error 2>/dev/null | jq 'has("name")')
if [[ ${ORG_SECRET} != "true" ]]; then
    printf ${GITHUB_ORG} | gcloud secrets create github-org --data-file=- > /dev/null
fi

[[ ${APPLICATION} == "nginx" ]] && echo -e "\e[95mStarting to deploy application ${APPLICATION}...\e[0m" && gcloud builds submit --config=modules/onboard-app/cloudbuild.yaml --substitutions=_PROJECT_ID=${PROJECT_ID},_APP_NAME=${APPLICATION},_GITHUB_ORG=${GITHUB_ORG},_GITHUB_EMAIL=${GITHUB_EMAIL},_GITHUB_USER=${GITHUB_USER},_GITHUB_TOKEN=${GITHUB_TOKEN}  --async

echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"