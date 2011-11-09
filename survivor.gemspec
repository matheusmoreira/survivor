#!/usr/bin/env gem build
# encoding: utf-8

# Add library into load path
$:.unshift File.expand_path('../lib', __FILE__)

require 'survivor/version'

Gem::Specification.new do |gem|

  gem.name     = 'survivor'
  gem.version  = Survivor::Version::STRING
  gem.summary  = 'Survival horror roguelike game'
  gem.author   = 'Matheus Afonso Martins Moreira'
  gem.homepage = 'https://github.com/matheusmoreira/survivor'

  gem.files         = `git ls-files`.split "\n"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map &File.method(:basename)

  gem.add_development_dependency 'bundler'

end
