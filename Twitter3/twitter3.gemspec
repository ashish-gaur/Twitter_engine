$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "twitter3/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "twitter3"
  s.version     = Twitter3::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Twitter3."
  s.description = "TODO: Description of Twitter3."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.18"
  s.add_dependency 'mysql2', '~> 0.3.14' 
  s.add_dependency 'taps'
  s.add_dependency 'will_paginate', '~> 3.0'
  s.add_dependency 'time_diff', '~> 0.3.0'
  s.add_dependency 'jquery-validation-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'rails3-jquery-autocomplete'
  # s.add_dependency "jquery-rails"

end
