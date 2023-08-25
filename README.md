## Apigee X WebSocket Test Util

This repo contains a sample WebSocket client, and WebSocket server that can be used
for testing and troubleshooting WebSockets with Apigee. 

* The WebSocket server simply echoes back whatever the client sends.


* The WebSocket client allows sends a message every second, and allows you to include an idle
period of inactivity (with `--idle-start`, `--idle-stop`)

### Setup

Clone this repo:
```shell
git clone https://github.com/micovery/apigee-websocket
cd apigee-websocket
```

Download and install Go tooling (if not done already)
```shell
./download-install-go.sh
```

Build WebSocket client (ws-client):

```shell
./build-client.sh
```

Setup PROJECT_ID, and login using gcloud
```shell
export PROJECT_ID=example-gcp-project
gcloud auth login
```

Deploy sample WebSocket Server to Cloud Run:

```shell
export REGION=us-west1
./deploy-websocket-cloud-run.sh
```

Test direct connection to WebSocket server:

```shell
export WEBSOCKET_CLOUD_RUN_URL=$(gcloud run services describe apigee-websocket --region us-west1 --format "get(status.url)")
./ws-client --address ws://${WEBSOCKET_CLOUD_RUN_URL}
```

Deploy Apigee API Proxy
```shell
export APIGEE_ORG=${PROJECT_ID}
export APIGEE_ENV=eval
./deploy-websocket-apiproxy.sh
```

Test connection to WebSocket server through Apigee:
```shell
export APIGEE_HOSTNAME=34.36.88.128.nip.io
```

```shell
./ws-client --address ws://${APIGEE_HOSTNAME}/ws
```

Test connection to WebSocket server with a 10 minutes idle period

```
./ws-client --address ws://${APIGEE_HOSTNAME}/ws --idle-start 10 --idle-stop 610
```

The command above will send traffic for 10 seconds, then idle for 10 minutes, and then resume sending traffic.
