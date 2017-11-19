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
  s.license     = 'AGPL-3.0'

  s.require_paths = ['lib', 'lib/m_monad']

  s.add_development_dependency 'bundler-audit', '~> 0.6'
  s.add_development_dependency 'pry-byebug', '~> 3.5'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.51'
  s.add_development_dependency 'rubocop-rspec', '~> 1.20'
  s.add_development_dependency 'simplecov', '~> 0.15'

  s.add_dependency 'cztop', '~> 0.11'
  s.add_dependency 'require_all', '~> 1.4'
end
