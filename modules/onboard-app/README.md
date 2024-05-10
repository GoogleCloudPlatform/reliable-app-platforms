# Onboard App - HOWTO

Onboard-app is how we adopt existing codebases into RAP.

This is a gitops CI/CD system that uses:

- GitHub
  - You need an Org to store your repos for each team or service (see below)
- Cloud Build for CI
- Cloud Deploy for CD

You will want to structure your app in the following manner:

1. app repo
1. infra repo

So, for an app named "myapp" you'll have:  "myapp" and "myapp-infra"

## onboard.sh

this script sets some variables and secrets, then calls `cloudbuild.yaml` on Cloud Build

it currently has app names hardcoded.

## cloudbuild.yaml

this sets up a terraform run with the appropriate values in place.

## onboard-app/main.tf

1. this creates the "app-infra" repository in your GitHub Org
1. it runs `prep-infra-repo.sh` - populating the "app-infra" repo appropriately, if it doesn't exist
1. it then creates a webhook in GitHub to notify Cloud Build about changes to that repo
1. it then creates a trigger in Cloud Build which does:
  1. clones the "app-infra" repo
  1. runs `terraform/platform-infra` from that repo

## onboard-app/infra-repo-template/terraform/platform-infra/main.tf

This becomes a part of the `app-infra` repo in your Org.  There its path is just `terraform/platform-infra/main.tf`.

This runs:

1. pulls down tf modules from RAP: `artifact_registry`, `deploy_pipeline`, and `endpoints`.
1. it runs `prep-app-repo.sh` - populating the "app" repo appropriately, if it doesn't exist
1. it pulls down the latest "app" repo
1. it then creates a webhook in GitHub to notify Cloud Build about changes to that repo
1. it then creates a trigger in Cloud Build which:
    1. creates and runs two Cloud Deploy releases:
        1. deploy-to-app-clusters
        1. deploy-to-other-clusters
    1. it then sets up SLOs (still WIP) as pulled from `modules/slos`
