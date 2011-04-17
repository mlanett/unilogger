require "logger"

module Unilogger
  
  class LogFileEmitter
    
    class << self
      def build( options )
        logdev = options.delete("logdev")
        case logdev
        when nil, /stderr/i
          new( STDERR, options.merge( :logdev => "STDERR" ) )
        when /stdout/i
          new( STDOUT, options.merge( :logdev => "STDOUT" ) )
        else
          new( logdev, options.merge( :logdev => logdev ) )
        end
      end
    end
    
    # options includes a JSON representation of logdev
    def initialize( logdev, options = {} )
      @options = options
      @logdev  = ::Logger::LogDevice.new( logdev, options )
      @level   = Builder.level_to_i( options["level"], ::Logger::Severity::DEBUG )
    end
    
    def emit( details, message, options )
      if details[:pri_num] >= @level then
        if options && options.size > 0 then
          options = options.map { |k,v| [k, v.to_json].join(":") }.join(",")
          message = "#{message}; #{options}"
        end
        @logdev.write "#{details[:time].to_i} [#{details[:pid]}:#{details[:fiber]}] #{details[:pri_sym]} #{message}\n"
      end
    end
    
    def as_json
      { :log_file => @options }
    end
    
  end # LogFileEmitter

end # Unilogger
