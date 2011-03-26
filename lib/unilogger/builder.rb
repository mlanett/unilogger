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
        
        if File.exist?( yml = root + "/test/logger.yml" ) then
          cfg = YAML.load(IO.read( yml )) [env]
        elsif File.exist?( yml = root + "/test/logger.yml.erb" )
          cfg = YAML.load( (ERB.new( IO.read( yml ) ).result) ) [env]
        end

        puts cfg.inspect
        puts Unilogger::Builder.new( cfg ).logger
      end
    end # class
    
    def initialize( configuration )
      @configuration = configuration
    end
    
    def logger
      # accept debug...fatal, 0...4, default info
      level = @configuration["level"]
      level = level ? level.kind_of?(Integer) ? level : Logger::Severity.const_get( level.to_s.upcase ) : Logger::Severity::INFO
      
      # emitters
      emitters = @configuration["emitters"].map do |options|
        kind    = options.delete("kind")
        kind    = "LogFileEmitter" if kind =~ /logger/i
        factory = kind.index("::") ? Object.const_get(kind) : Unilogger.const_get(kind)
        factory.build( options )
      end
      
      Logger.new( level, emitters )
    end
    
  end
end
