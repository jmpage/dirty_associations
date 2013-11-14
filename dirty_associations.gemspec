$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dirty_associations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dirty_associations"
  s.version     = DirtyAssociations::VERSION
  s.authors     = ["Jen Page"]
  s.email       = ["jenipage1989@gmail.com"]
  s.homepage    = "https://github.com/jmpage/dirty_associations"
  s.summary     = "Provides a concern for monitoring changes to has_many associations."
  s.description = "Provides a concern for monitoring changes to has_many associations using ActiveModel::Dirty."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
end
