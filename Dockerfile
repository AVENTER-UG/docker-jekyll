FROM  jekyll/jekyll:4.2.2 as BUILDER


FROM ruby:alpine

LABEL maintainer="Andreas Peters <support@aventer.biz>"

COPY --from=builder /usr/jekyll /usr/

ENV JEKYLL_VERSION=4.2.2
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV GIT_REPO https://
ENV av_logging off

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G jekyll jekyll

RUN gem install bundle
RUN apk add gettext nginx git bash
RUN apk --no-cache add linux-headers openjdk8-jre less zlib libxml2 \
    readline libxslt libffi nodejs tzdata shadow su-exec npm libressl yarn
RUN apk --no-cache add zlib-dev libffi-dev build-base libxml2-dev \
    imagemagick-dev readline-dev libxslt-dev libffi-dev yaml-dev zlib-dev \
    vips-dev vips-tools sqlite-dev cmake    
RUN apk update

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


