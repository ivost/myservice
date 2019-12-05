NAME := myservice

BUILD_TARGET = build
GO := go
GO_NOMOD := GO111MODULE=off go

# dockerhub
DOCKER_REPO=ivostoy
DAEMON=
VERSION=0.12.5.0

# Make does not offer a recursive wildcard function, so here's one:
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

GO_VERSION := $(shell $(GO) version | sed -e 's/^[^0-9.]*\([0-9.]*\).*/\1/')
GO_DEPENDENCIES := $(call rwildcard,pkg/,*.go) $(call rwildcard,cmd/,*.go)

BRANCH     := $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null  || echo 'unknown')
BUILD_DATE := $(shell date +%Y%m%d-%H:%M:%S)

GIT_COMMIT=$(shell git describe --dirty --always  2> /dev/null  || echo 'unknown')

#PKG=github.com/ivost/myservice/pkg
PKG=github.com/ivost/shared/pkg
BUILDFLAGS=-ldflags "-s -w -X ${PKG}/version.Version=${VERSION} -X ${PKG}/version.Build=${GIT_COMMIT}"

CGO_ENABLED = 0

IMG_TAG=${VERSION}-${GIT_COMMIT}
IM=${DOCKER_REPO}/${NAME}
IMG=${IM}:${IMG_TAG}

# build container
IMG_BLD_TAG=build_${VERSION}
IMG_BLD=${DOCKER_REPO}/${NAME}:${IMG_BLD_TAG}
# kustomize
BASE=./k8s/base
OVERLAYS=./k8s/overlays

#POD:=$(shell kubectl get pod -l app=myservice -o  jsonpath='{.items[*].metadata.name}') > /dev/nul

include ../shared/shared.mk

