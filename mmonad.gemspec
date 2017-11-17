# frozen_string_literal: true

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'mmonad'
  s.version     = MMonad::VERSION
  s.summary     = 'Messaging Monad'
  s.description = 'Messaging Monad, backed by 0MQ'
  s.authors     = ['Jared Davis']
  s.email       = 'jared@haiq.us'
  s.files       = Dir['lib/**/*', 'README*', 'CHANGELOG*', 'LICENSE']
  s.homepage    = 'https://github.com/Jared-Prime/mmonad'

  s.add_development_dependency 'bundler-audit'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'

  s.add_dependency 'cztop'
  s.add_dependency 'require_all'
end
