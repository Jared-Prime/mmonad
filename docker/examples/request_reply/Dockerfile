FROM jprime/mmonad:base

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

COPY request_reply/example.rb example.rb

CMD ["bundle", "exec", "example.rb"]