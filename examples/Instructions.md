cd whereami-frontend/app-repo/

```sh

gcloud builds submit . \
--substitutions=_REGION=us-central1,\
_PROJECT_ID=${PROJECT_ID}
```