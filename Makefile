#Dockerfile vars

#vars
TAG=4.2.2
IMAGENAME=docker-jekyll
IMAGEFULLNAME=avhost/${IMAGENAME}
BRANCH=${shell git symbolic-ref --short HEAD}
LASTCOMMIT=$(shell git log -1 --pretty=short | tail -n 1 | tr -d " " | tr -d "UPDATE:")

.DEFAULT_GOAL := all

ifeq (${BRANCH}, master) 
        BRANCH=latest
endif

ifneq ($(shell echo $(LASTCOMMIT) | grep -E '^v([0-9]+\.){0,2}(\*|[0-9]+)'),)
        BRANCH=${LASTCOMMIT}
else
        BRANCH=latest
endif

build:
	@echo ">>>> Build docker image"
	@docker buildx build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCH} .

push:
	@echo ">>>> Publish docker image: " ${BRANCH}
	@docker buildx create --use --name buildkit
	@docker buildx build --platform linux/amd64 --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx rm buildkit


all: build push
