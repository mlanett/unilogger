require "logger"

module Unilogger
  class Builder
    
    def initialize( configuration )
      @configuration = configuration
    end
    
    def logger
      # accept debug...fatal, 0...4, default info
      level = @configuration["level"]
      level = level ? level.kind_of?(Integer) ? level : Logger::Severity.const_get( level.to_s.upcase ) : Logger::Severity::INFO
      
      # emitters
      emitters = @configuration["emitters"].map do |options|
        kind = options.delete("kind")
        if kind =~ /logger/i then
          # ruby Logger
          # for device, accept STDERR, STDOUT, or a filename
          # for shift_age, accept daily, weekly, monthly, or a number, default 7; @see Ruby Logger
          # if shift_age is numeric, for shift_size, accept a number, default 1048576; @see Ruby Logger
          device = options["device"]
          device = case device when nil; STDERR; when /stderr/i; STDERR; when /stdout/i; STDOUT; else device; end
          params = [ device, options["shift_age"], options["shift_size"] ].compact
          emitter = ::Logger.send( :new, *params )
        else
          factory = kind.index("::") ? Object.const_get(kind) : Unilogger.const_get(kind)
          factory.build( options )
        end
      end
      
      Logger.new( level, emitters )
    end
    
  end
end
