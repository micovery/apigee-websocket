#!/bin/bash

gcloud run deploy apigee-websocket --allow-unauthenticated --timeout 3600 --region=us-west1 --source=.