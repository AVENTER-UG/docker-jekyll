FROM centos:latest
MAINTAINER Andreas Peters <mailbox@andreas-peters.net>

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum install -y rubygems ruby-devel gcc make nodejs git zlib zlib-devel && \
    gem install --verbose --no-rdoc --no-ri jekyll && \
    gem install RedCloth --version 4.2.2 && \
    gem install bundle && \
    yum clean all

EXPOSE 4000


COPY jekyll-entrypoint.sh entrypoint.sh
CMD ["/bin/bash"]


