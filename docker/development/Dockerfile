FROM jprime/mmonad:base

COPY Gemfile ./
COPY Gemfile.lock ./
COPY mmonad.gemspec ./
COPY lib/version.rb lib/version.rb

RUN bundle install

COPY . ./