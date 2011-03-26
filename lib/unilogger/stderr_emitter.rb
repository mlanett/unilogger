require "logger"
require "json"

module Unilogger
  
  # Adds pid and timestamp to each log entry.
  # Implements IO API (<<) which bypasses levels and EOL.
  # Implements Logger API (debug, info, warn, error, fatal)
  class StderrEmitter
    
    class << self
      def build( options )
        new
      end
    end
    
    def initialize( io = STDERR )
      @io = io
    end
    
    def emit( details, message, options )
      message = "#{message}; #{options.to_json}" if options && options.size > 0
      @io.puts "#{details[:time].to_i} [#{details[:pid]}] #{details[:pri_sym]} #{message}"
    end
    
  end # StderrEmitter

end # Unilogger
