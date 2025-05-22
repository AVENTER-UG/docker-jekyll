FROM ruby:alpine3.21

LABEL maintainer="Andreas Peters <support@aventer.biz>"

ENV JEKYLL_VERSION=4.4.1
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV GIT_REPO https://
ENV av_logging off

RUN apk update
RUN apk add jekyll
RUN apk add gettext nginx git bash
RUN apk add linux-headers openjdk8-jre less zlib libxml2 \
    readline libxslt libffi nodejs tzdata shadow su-exec npm libressl yarn
RUN apk add zlib-dev libffi-dev build-base libxml2-dev \
    imagemagick-dev readline-dev libxslt-dev libffi-dev yaml-dev zlib-dev \
    vips-dev vips-tools sqlite-dev cmake
RUN apk upgrade


RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G jekyll jekyll

RUN mkdir -p /var/www/html && \
    mkdir -p /var/cache/nginx && \
    chown -R jekyll: /var/www/html && \
    chown -R jekyll: /var/cache/nginx && \
    chown -R jekyll: /run/nginx


EXPOSE 8888

COPY jekyll-entrypoint.sh /bin/entrypoint.sh
COPY nginx.conf.ini /tmp/nginx.conf.ini

RUN cd /home/jekyll && \
    chown -R jekyll: /usr/gem && \
    bundle install; exit 0

WORKDIR /var/www/html

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["/usr/sbin/nginx"]


