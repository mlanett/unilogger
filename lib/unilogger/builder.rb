require "erb"
require "unilogger/logger"
require "yaml"

module Unilogger
  class Builder
    
    class << self
      
      # options must include
      # env => "development", "test", "production", etc.
      # root => parent of config and log directories
      def build( options )
        env  = options[:env] || ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"
        root = options[:root]
        
        if File.exist?( yml = "#{root}/config/logger.yml" ) then
          cfg = YAML.load(IO.read( yml )) [env]
        elsif File.exist?( yml = "#{root}/config/logger.yml.erb" )
          cfg = YAML.load( (ERB.new( IO.read( yml ) ).result) ) [env]
        else
          cfg = { "level" => "debug", "emitters" => [ { "logger" => { "logdev" => "stderr" } } ] }
        end
        
        Unilogger::Builder.new( cfg ).logger
      end
      
      def level_to_i( level, default_level = ::Logger::Severity::INFO )
        return default_level if level.nil? || level.size == 0
        return level if level.kind_of?(Integer)
        ::Logger::Severity.const_get( level.to_s.upcase )
      end
      
      def as_factory( kind )
        kind = "LogFileEmitter" if kind =~ /^logger$/i
        factory = Unilogger.const_get(kind) rescue Object.const_get(kind) rescue nil
        raise "unknown kind of emitter (#{kind})" if ! factory
        return factory
      end
      
    end # class
    
    def initialize( configuration )
      @configuration = configuration
    end
    
    def logger
      # accept debug...fatal, 0...4, default info
      level = self.class.level_to_i( @configuration["level"] )
      
      # emitters
      emitters = @configuration["emitters"].map do |options|
        options = options.first
        kind    = options.first
        factory = self.class.as_factory( kind )
        factory.build( options.last )
      end
      
      Logger.new( level, emitters )
    end
    
  end
end
