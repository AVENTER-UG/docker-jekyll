#Dockerfile vars

#vars
TAG=4.2.2
IMAGENAME=docker-jekyll
IMAGEFULLNAME=avhost/${IMAGENAME}
IMAGETAG=v4.2.2-3

.DEFAULT_GOAL := all

build:
	@echo ">>>> Build docker image"
	@docker buildx build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCH} .

push:
	@echo ">>>> Publish docker image: " ${IMAGETAG}
	@docker buildx create --use --name buildkit
	@docker buildx build --platform linux/amd64 --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:latest .
	@docker buildx build --platform linux/amd64 --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${IMAGETAG} .
	@docker buildx rm buildkit


all: build push
