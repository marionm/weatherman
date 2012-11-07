$:.push File.expand_path("../lib", __FILE__)
require "weatherman/version"

Gem::Specification.new do |s|
  s.name        = "weatherman"
  s.version     = Weatherman::VERSION
  s.authors     = ["Mike Marion"]
  s.email       = ["mike.marion@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Helps collect custom CloudWatch metrics}
  s.description = %q{Weatherman is for periodically collecting metrics and reporting them to CloudWatch}

  s.rubyforge_project = "weatherman"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_runtime_dependency "fog", "~> 1.7.0"
  s.add_runtime_dependency "ohai", "~> 6.14.0"
end
