FROM centos:latest
MAINTAINER Andreas Peters <mailbox@andreas-peters.net>

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GIT_REPO https://

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum install -y rubygems ruby-devel gcc make nodejs git zlib zlib-devel nginx && \
    gem install --verbose --no-rdoc --no-ri jekyll && \
    gem install RedCloth --version 4.2.2 && \
    gem install bundle && \
    mkdir -p /var/www/html && \
    yum clean all

EXPOSE 8888


COPY jekyll-entrypoint.sh /bin/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf


ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["/usr/sbin/nginx"]

