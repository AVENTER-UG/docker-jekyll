#Dockerfile vars

#vars
TAG=4.2.2
IMAGENAME=docker-jekyll
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGETAG=v4.2.2-3
BRANCH=$(shell git symbolic-ref --short HEAD | xargs basename)
BRANCHSHORT=$(shell echo ${BRANCH} | awk -F. '{ print $$1"."$$2 }')
BUILDDATE=$(shell date -u +%Y%m%d)

.DEFAULT_GOAL := all

build:
	@echo ">>>> Build docker image"
	@docker buildx build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCH} .

push:
	@echo ">>>> Publish docker image: " ${IMAGETAG}
	@docker buildx create --use --name buildkit
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --push --build-arg TAG=${BRANCH} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx build --sbom=true --provenance=true --platform linux/amd64 --push --build-arg TAG=${BRANCH} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCHSHORT} .
	@docker buildx rm buildkit


all: build push
