$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dirty_relations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dirty_relations"
  s.version     = DirtyRelations::VERSION
  s.authors     = ["Jen Page"]
  s.email       = ["jenipage1989@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Provides a concern for monitoring changes to relations."
  s.description = "Provides a concern for monitoring changes to relations in ActiveRecord models."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
end
