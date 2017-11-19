# frozen_string_literal: true

namespace :docker do
  desc 'run the development container image'
  task run: [:build] do
    Kernel.exec('docker-compose up')
  end

  desc 'build the development container image'
  task :build do
    `docker-compose build`
  end

  desc 'run tests on the development container image'
  task test: :build do
    Kernel.exec('docker run -it jprime/mmonad:development bundle exec rspec')
  end

  desc 'remove containers and unused images'
  task :clean do
    Kernel.exec('docker-compose down && docker images | awk \'/<none>/{ print $3 }\' | xargs docker rmi')
  end
end

desc 'Run rubocop locally'
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
