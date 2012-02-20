# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-hack/version"

Gem::Specification.new do |s|
  s.name        = "git-hack"
  s.version     = Git::Hack::VERSION
  s.authors     = ["weizhao"]
  s.email       = ["azhao.1981@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Facade of git. Make git easy to use.}
  s.description = %q{A more smart tools of git. Come from git-smart}

  s.rubyforge_project = "git-hack"

  s.files         = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin`.split("\n").map{|f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "colorize"
end
