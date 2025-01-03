# syntax=docker/dockerfile:1

ARG ruby_version=3.4
ARG freetds_version=1.3.9

FROM ruby:${ruby_version}

ARG node_version
ARG freetds_version

RUN apt-get update -qq

# FreeTDS
RUN apt-get install -y --no-install-recommends automake autoconf libtool make gcc perl gettext gperf git

RUN curl -fsSL https://github.com/FreeTDS/freetds/archive/refs/tags/v${freetds_version}.tar.gz -o freetds-${freetds_version}.tar.gz && \
    tar -xzf freetds-${freetds_version}.tar.gz && \
    cd freetds-${freetds_version} && \
    git init && git config user.email "n/a" && git config user.name "n/a" && touch blank && git add blank && git commit -m "a commit" && \
    ./autogen.sh --prefix=/usr/local --with-tdsver=7.3 && \
    make && \
    make install

# Misc tools
RUN apt-get install -y --no-install-recommends gpg curl tar jq libasound2

# create app user & home directory
RUN adduser --uid 55555 --home /home/appuser --disabled-password --gecos "" appuser
WORKDIR /home/appuser

USER appuser
RUN gem install bundler:2.4.22
USER root
