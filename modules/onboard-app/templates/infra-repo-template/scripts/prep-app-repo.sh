#!/bin/sh

application_name=${1}
github_org=${2}
github_user=${3}
github_email=${4}
github_token=${5}
github_repo="${6}"
project_id=${7}
template_repo="/tmp/reliable-app-platforms"
template_path="${template_repo}/modules/onboard-app/templates"
source_repo="/tmp/${github_repo}"
#Copy the template from reliable-app-platforms
#TODO: change the branch and orgname in the below clone command
git clone "https://github.com/GoogleCloudPlatform/reliable-app-platforms" "${template_repo}"

#Now clone new application repo and copy the template into it
git clone  https://${github_user}:${github_token}@github.com/${github_org}/${github_repo} ${source_repo}
if  [ "${application_name}" = "nginx" ]; then
  app_version="1.14.2"
fi
cp -r ${template_path}/app-repo-template/* ${source_repo}
cd ${source_repo}
find . -type f  -exec  sed -i "s?APP_NAME?${application_name}?g" {} +
find . -type f  -exec  sed -i "s?APP_VERSION?${app_version}?g" {} +
find . -type f  -exec  sed -i "s?PROJECT_ID?${project_id}?g" {} +
git config --global user.name ${github_user}
git config --global user.email ${github_email}
git add .
git commit -m "IGNORE : Setting up ${github_repo}"
git push origin main
rm -rf "${template_repo}"
rm -rf "${source_repo}"