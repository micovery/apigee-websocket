FROM --platform=linux/amd64 ubuntu:22.04

LABEL maintainer="miguelmendoza@google.com.com"

ARG PORT=8080
EXPOSE ${PORT}

# GoLang
ARG GO_VERSION=1.20.6
ARG GO_TARGZ_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

# install core utilities
RUN apt-get update && apt-get install -y curl zip unzip

RUN echo "**** Download and install golang version: ${GO_VERSION}" \
    && echo "**** url: ${GO_TARGZ_URL}" \
    && curl -o go.tar.gz -sfL "${GO_TARGZ_URL}"  \
    && tar -xvf "go.tar.gz" \
    && mv go go-sdk \
    && mkdir go

ENV PATH="${PATH}:/go-sdk/bin:/go/bin"

RUN mkdir /app
COPY * /app/

RUN echo "*** Build application" \
    && cd /app \
    && ls -la \
    && export GOPATH=/go \
    && export GOROOT=/go-sdk \
    && export GOARCH=amd64 \
    && export GOOS=linux \
    && go build -o ws  server/main.go

RUN echo "*** Setting env "
ENV GOPATH /go
ENV GOROOT /go-sdk
ENV GOARCH amd64
ENV GOOS linux

ENTRYPOINT ["bash", "-c", "/app/ws"]