FROM  jekyll/jekyll:4.0
LABEL maintainer="Andreas Peters <support@aventer.biz>"

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV GIT_REPO https://
ENV av_logging off
ENV DEBIAN_FRONTEND noninteractive

RUN gem install bundle
RUN apk add gettext nginx git
RUN mkdir -p /var/www/html && \
    mkdir -p /var/cache/nginx && \    
    chown -R jekyll: /var/www/html && \
    chown -R jekyll: /var/cache/nginx && \
    mkdir /run/nginx && \
    chown -R jekyll: /run/nginx


EXPOSE 8888

COPY jekyll-entrypoint.sh /bin/entrypoint.sh
COPY nginx.conf.ini /tmp/nginx.conf.ini

WORKDIR /var/www/html

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["/usr/sbin/nginx"]


