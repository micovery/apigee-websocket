#!/bin/bash

set -e

REGION=${REGION:-us-west1}

gcloud services enable \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com

gcloud run deploy apigee-websocket \
   --allow-unauthenticated \
   --timeout 3600 \
   --region="${REGION}" \
   --source=.