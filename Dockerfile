FROM node:10-stretch

LABEL "com.github.actions.name"="Camel Website tooling"
LABEL "com.github.actions.description"="Nodejs with tools for Camel Website"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/apache/camel-website"
LABEL "homepage"="https://camel.apache.org"
LABEL "maintainer"="Camel Developers <dev@camel.apache.org>"

RUN set -ex \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxss1 \
    libxtst6 \
    jq \
  && rm -rf /var/lib/apt/lists/*

ADD publish /usr/local/bin

ADD package.json /tmp
ADD yarn.lock /tmp
ADD .yarnrc /tmp

RUN yarn --non-interactive --frozen-lockfile --cwd /tmp install

ADD antora-ui-camel/package.json /tmp
ADD antora-ui-camel/yarn.lock /tmp

RUN yarn --non-interactive --frozen-lockfile --cwd /tmp install
RUN rm -rf /tmp/*

