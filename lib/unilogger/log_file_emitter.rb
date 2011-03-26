require "logger"

module Unilogger
  
  class LogFileEmitter
    
    class << self
      def build( options )
        logdev = options.delete("logdev")
        case logdev
        when nil, /stderr/i
          new( STDERR )
        when /stdout/i
          new( STDOUT )
        else
          new( logdev, options )
        end
      end
    end
    
    # options may include
    # shift_age, daily, weekly, monthly, or N, default 7
    # shift_size, N>0, default 1048576
    def initialize( logdev, options = {} )
      @logdev = ::Logger::LogDevice.new( logdev, options )
    end
    
    def emit( details, message, options )
      message = "#{message}; #{options.to_json}" if options && options.size > 0
      @logdev.write "#{details[:time].to_i} [#{details[:pid]}] #{details[:pri_sym]} #{message}"
    end
    
  end # LogFileEmitter

end # Unilogger
