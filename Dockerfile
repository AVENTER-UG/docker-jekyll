FROM avhost/docker-jekyll:4.0.0

LABEL maintainer="Andreas Peters <support@aventer.biz>"

RUN apk upgrade
RUN rm -rf /var/cache/apk/*

