FROM ruby:3.0 as BUILDER

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog locales 2>&1 \
    # Verify git, process tools installed
    && apt-get -y install git openssh-client iproute2 procps lsb-release \
    #
    # Install ruby-debug-ide and debase
    && gem install ruby-debug-ide \
    && gem install debase \
    #
    # Install node.js
    && apt-get -y install curl software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get -y install nodejs \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog


FROM ruby:alpine

LABEL maintainer="Andreas Peters <support@aventer.biz>"

COPY --from=builder /usr/jekyll /usr/

ENV JEKYLL_VERSION=4.4.1
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


