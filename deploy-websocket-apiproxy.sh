#!/bin/bash

set -e

WEBSOCKET_CLOUD_RUN_URL=$(gcloud run services describe apigee-websocket --region us-west1 --format "get(status.url)")
PROJECT_ID=$(gcloud config get project)

if [ -z "${PROJECT_ID}" ] ; then
  echo "PROJECT_ID is not set"
  exit 1
fi


if [ -z "${WEBSOCKET_CLOUD_RUN_URL}" ] ; then
  echo "could not get url for the apigee-websocket cloud-run service"
  exit 1
fi

echo "WEBSOCKET_CLOUD_RUN_URL=${WEBSOCKET_CLOUD_RUN_URL}"
sed -i.bak -e  "s%<URL>.*</URL>%<URL>${WEBSOCKET_CLOUD_RUN_URL}</URL>%" apiproxy/targets/default.xml
rm apiproxy/targets/default.xml.bak

export TOKEN="$(gcloud  auth print-access-token)"
APIGEE_ENV=${APIGEE_ENV:-eval}
APIGEE_ORG=${PROJECT_ID}

echo "APIGEE_ENV=${APIGEE_ENV}"
echo "APIGEE_ORG=${APIGEE_ORG}"

./apigeecli apis create bundle \
  --token "${TOKEN}" \
  --org "${APIGEE_ORG}" \
  --proxy-folder ./apiproxy \
  --name ws

./apigeecli apis deploy \
  --token "${TOKEN}" \
  --org "${APIGEE_ORG}" \
  --env "${APIGEE_ENV}" \
  --name ws  \
  --ovr \
  --wait