FROM golang:1.17-alpine AS build

RUN set -ex && \
    apk --no-cache --update add \
        git curl

ENV GOARCH=amd64 \
    CGO_ENABLED=0

WORKDIR /go/src

COPY go.mod .
COPY go.sum .

RUN echo "magic number avoid layer cache" && \
    curl -iv https://goproxy.cn/cloud.google.com/go/iam/@v/v0.3.0.info && \
    GOPROXY=goproxy.cn,direct go mod download || \
    curl -iv https://goproxy.cn/cloud.google.com/go/iam/@v/v0.3.0.info

COPY . .

RUN GOPROXY=goproxy.cn,direct go build istioctl/cmd/istioctl/main.go
