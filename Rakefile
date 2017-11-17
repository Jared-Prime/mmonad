# frozen_string_literal: true

namespace :docker do
  desc 'run the container image'
  task run: [:build] do
    Kernel.exec('docker-compose up')
  end

  desc 'build the container image'
  task :build do
    `docker-compose build`
  end
end

desc 'Run rubocop'
task :rubocop, [:autocorrections] do |_t, args|
  if args[:autocorrections]
    `bundle exec rubocop -a`
  else
    `bundle exec rubocop`
  end
end

desc 'Run rubocop and rspec'
task test: [:rubocop] do
  `bundle exec rspec`
end

task default: :test
