FROM ruby:2.4.2

MAINTAINER Jared Davis <jared@haiq.us>

ARG libzmq=https://github.com/zeromq/libzmq/releases/download/v4.2.2/zeromq-4.2.2.tar.gz
ARG czmq=https://github.com/zeromq/czmq/releases/download/v4.0.2/czmq-4.0.2.tar.gz

RUN apt-get update \
  && apt-get install -qy wget automake vim bash gcc libsodium-dev \
  && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
  && dpkg -i dumb-init_*.deb \
  && wget -qO- $libzmq | tar xvz -C /usr/local \
  && cd /usr/local/zeromq-4.2.2 && ./autogen.sh \
  && ./configure --with-libsodium && make install && ldconfig \
  && wget -qO- $czmq | tar xvz -C /usr/local \
  && cd /usr/local/czmq-4.0.2 && ./configure && make install && ldconfig \
  && apt-get clean

COPY docker-init.d /root/docker-init.d

RUN mkdir -p /usr/local/mmonad

WORKDIR /usr/local/mmonad

COPY Gemfile ./
COPY Gemfile.lock ./
COPY mmonad.gemspec ./
COPY lib/version.rb lib/version.rb

RUN bundle install

COPY . ./

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/root/docker-init.d/default.sh"]

CMD ["echo", "hello from mmonad!"]