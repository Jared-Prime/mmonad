FROM jprime/mmonad:base

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY vendor vendor

RUN bundle install --path vendor

COPY request_reply/example.rb example.rb

CMD ["bundle", "exec", "example.rb"]