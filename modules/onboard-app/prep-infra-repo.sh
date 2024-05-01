#!/bin/sh

application_name=${1}
github_org=${2}
github_user=${3}
github_email=${4}
github_token=${5}
github_repo=${6}
git clone  https://${github_user}:${github_token}@github.com/${github_org}/${github_repo} repo
cp -r templates/infra-repo-template/* repo
cd repo
find terraform -type f  -exec  sed -i "s?^APP_NAME?${application_name}?g" {} +
find terraform/platform-infra -type f -name backend.tf -exec  sed -i "s?APP_NAME?${application_name}?g" {} +
git config --global user.name ${github_user}
git config --global user.email ${github_email}
git add .
git commit -m "IGNORE : Setting up ${github_repo}"
git push origin main