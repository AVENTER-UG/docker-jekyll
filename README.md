# Docker image to use jekyll

[![Build Status](https://travis-ci.org/AVENTER-UG/docker-jekyll.svg?branch=master)](https://travis-ci.org/AVENTER-UG/docker-jekyll)

Please don't forget to donate a small fee: [![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/AVENTER/donate)


This Docker image will clone your jekyll GIT Repo, "compile" your website via jekyll and publish it via nginx. Important to know is, if you use bundle, this image will see it and use it too.

## Github Repo

[https://github.com/AVENTER-UG](https://github.com/AVENTER-UG)

## Dockerfile

```
FROM centos:latest
MAINTAINER Andreas Peters <support@aventer.biz>

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GIT_REPO https://

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum groupinstall -y "Development Tools" && \
    yum install -y nodejs git nginx ruby ruby-devel rubygems && \
    gem install --no-rdoc --no-ri jekyll && \
    gem install RedCloth --version 4.2.2 && \
    gem install bundle && \
    mkdir -p /var/www/html && \
    yum clean all

EXPOSE 8888


COPY jekyll-entrypoint.sh /bin/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf


ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["/usr/sbin/nginx"]
```

## Marathon

```
{
  "id": "/homepages/<HOMEPAGENAME>",
  "cmd": null,
  "cpus": 0.2,
  "mem": 200,
  "disk": 0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [],
    "docker": {
      "image": "docker.io/avhost/jekyll",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8888,
          "hostPort": 0,
          "protocol": "tcp",
          "labels": {}
        }
      ],
      "privileged": false,
      "forcePullImage": true
    }
  },
  "env": {
    "GIT_REPO": "https://github.com/<YOUR REPO>
  },
  "labels": {
    "HAPROXY_0_REDIRECT_TO_HTTPS": "true",
    "HAPROXY_GROUP": "external",
    "HAPROXY_0_VHOST": "aventer.<MESOS DOMAIN>
  }
}
```