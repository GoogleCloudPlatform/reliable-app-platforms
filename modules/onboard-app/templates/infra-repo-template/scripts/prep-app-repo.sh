#!/bin/sh

application_name=${1}
github_org=${2}
github_user=${3}
github_email=${4}
github_token=${5}
github_repo="${6}"
#Copy the template from reliable-app-platforms
git clone "https://github.com/GoogleCloudPlatform/reliable-app-platforms" reliable-app-platforms
cp -r reliable-app-platforms/modules/onboard-app/templates/app-repo-template .
rm -rf reliable-app-platforms
#Now clone new application repo and copy the template into it
git clone  https://${github_user}:${github_token}@github.com/${github_org}/${github_repo} repo
echo `ls -lrt`
if  [ "${application_name}" = "nginx" ]; then
  app_version="1.14.2"
fi
cp -r app-repo-template/* repo
cd repo
find . -type f  -exec  sed -i "s?APP_NAME?${application_name}?g" {} +
find . -type f  -exec  sed -i "s?APP_VERSION?${app_version}?g" {} +
git config --global user.name ${github_user}
git config --global user.email ${github_email}
git add .
git commit -m "Setting up ${github_repo}"
git push origin main
