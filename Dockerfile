FROM centos:latest
LABEL maintainer="Andreas Peters <support@aventer.biz>"

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GIT_REPO https://

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum groupinstall -y "Development Tools" && \
    yum install -y gcc openssl-devel make nodejs git zlib zlib-devel nginx wget && \
    wget http://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.1.tar.gz && \
    tar xvfvz ruby-2.6.1.tar.gz && \
    cd ruby-2.6.1 && \
    ./configure && \
    make && \
    make install && \
    gem update --system && \
    gem install jekyll && \
    gem install RedCloth --version 4.2.2 && \
    gem install bundle && \
    mkdir -p /var/www/html && \
    mkdir -p /var/cache/nginx && \
    chown -R nginx: /var/www/html && \
    chown -R nginx: /var/cache/nginx && \
    yum clean all 

EXPOSE 8888

COPY jekyll-entrypoint.sh /bin/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html

ENTRYPOINT ["/bin/entrypoint.sh"]

USER nginx

CMD ["/usr/sbin/nginx"]

