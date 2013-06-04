# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gcm_for_chrome/version'

Gem::Specification.new do |gem|
  gem.name          = "gcm_for_chrome"
  gem.version       = GcmForChrome::VERSION
  gem.authors       = ["henteko"]
  gem.email         = ["henteko07@gmail.com"]
  gem.description   = %q{Google Cloud Message for Chrome gem}
  gem.summary       = %q{Google Cloud Message for Chrome gem}
  gem.homepage      = "https://github.com/henteko/gcm_for_chrome"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rest-client"
  gem.add_dependency "json"
  gem.add_development_dependency 'rake', '~> 0.9.2.2'
  gem.add_development_dependency 'rdoc', '~> 3.12'
  gem.add_development_dependency 'rspec'
end
