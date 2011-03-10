# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "unilogger/version"

Gem::Specification.new do |s|
  s.name        = "unilogger"
  s.version     = Unilogger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Lanett"]
  s.email       = ["mark.lanett@gmail.com"]
  s.homepage    = ""
  s.summary     = "Unified logger that writes to a log file, redis queue, mongo collection, and hoptoad."
  
  s.rubyforge_project = "unilogger"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
