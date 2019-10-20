FROM centos:latest
LABEL maintainer="Andreas Peters <support@aventer.biz>"

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GIT_REPO https://

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum groupinstall -y "Development Tools" && \
    yum install --nogpgcheck -y nodejs git nginx ruby ruby-devel rubygems && \
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

CMD ["/usr/sbin/nginx"]

