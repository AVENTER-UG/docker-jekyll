#Dockerfile vars

#vars
TAG=4.0.0-1
IMAGENAME=docker-jekyll
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGETAG=v4.0.0-1

.DEFAULT_GOAL := all

build:
	@echo ">>>> Build docker image"
	@docker build --build-arg TAG=${TAG} -t ${IMAGEFULLNAME}:${IMAGETAG} .

push:
	@echo ">>>> Publish docker image: " ${IMAGETAG}
	@docker buildx create --use --name buildkit
	@docker buildx build --platform linux/amd64 --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${IMAGETAG} .
	@docker buildx rm buildkit

all: build
