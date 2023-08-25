#!/bin/bash

export GOPATH=$HOME/go
export GOROOT=$HOME/go-sdk
export GOARCH=amd64
export GOOS=linux
export PATH=$HOME/go-sdk/bin:$PATH

go build -o ws-client pkg/client/main.go