#Dockerfile vars

#vars
TAG=4.4.1-2
IMAGENAME=docker-jekyll
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGETAG=v4.4.1
BRANCH=${IMAGETAG}
BRANCHSHORT=$(shell echo ${BRANCH} | awk -F. '{ print $$1"."$$2 }')
BUILDDATE=$(shell date -u +%Y%m%d)

.DEFAULT_GOAL := all

sboom:
	syft dir:. > sbom.txt
	syft dir:. -o json > sbom.json

seccheck:
	grype --add-cpes-if-none .

imagecheck:
	grype --add-cpes-if-none ${IMAGEFULLNAME}:latest > cve-report.md

build:
	@echo ">>>> Build docker image"
	@docker build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:latest .

push:
	@echo ">>>> Publish docker image: " ${BRANCH}
	@docker buildx create --use --name buildkit
	@docker buildx build  --sbom=true --provenance=true  --platform linux/arm64,linux/amd64 --push -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx build  --sbom=true --provenance=true  --platform linux/arm64,linux/amd64 --push -t ${IMAGEFULLNAME}:latest .
	@docker buildx rm buildkit

all: build seccheck imagecheck sboom
