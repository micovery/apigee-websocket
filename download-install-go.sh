#!/bin/bash

export GO_VERSION=1.20.6
export GO_TARGZ_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

sudo apt-get update
sudo apt-get install -y curl

curl -o go.tar.gz -sfL "${GO_TARGZ_URL}"
tar -xvf "go.tar.gz"
mv go $HOME/go-sdk
mkdir $HOME/go
