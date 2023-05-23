[[ ! "${PROJECT_ID}" ]] && echo -e "Please export PROJECT_ID variable (\e[95mexport PROJECT_ID=<YOUR POROJECT ID>\e[0m)\nExiting." && exit 0
echo -e "\e[95mPROJECT_ID is set to ${PROJECT_ID}\e[0m"
gcloud config set core/project ${PROJECT_ID}
echo -e "\e[95mEnabling Cloudbuild API in ${PROJECT_ID}\e[0m"
gcloud services enable cloudbuild.googleapis.com
echo -e "\e[95mAssigning Cloudbuild Service Account roles/owner in ${PROJECT_ID}\e[0m"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com --role roles/owner
echo -e "\e[95mStarting Cloudbuild to create infrastructure...\e[0m"
gcloud builds submit --config=builds/infra.yaml --substitutions=_PROJECT_ID=${PROJECT_ID} --async
echo -e "\e[95mYou can view the Cloudbuild status through https://console.cloud.google.com/cloud-build\e[0m"
