#!/usr/bin/env ruby

root = File.expand_path( "../..", __FILE__ )
env  = ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"

$: << root + "/lib"
require "erb"
require "unilogger"
require "unilogger/builder"
require "yaml"

if File.exist?( yml = root + "/test/logger.yml" ) then
  cfg = YAML.load(IO.read( yml )) [env]
elsif File.exist?( yml = root + "/test/logger.yml.erb" )
  cfg = YAML.load( (ERB.new( IO.read( yml ) ).result) ) [env]
end

puts cfg.inspect
puts Unilogger::Builder.new( cfg ).logger
