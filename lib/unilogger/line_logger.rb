require "logger"

module Unilogger
  
  # Stringifies each log entry to a single line of text.
  # Writes to a traditional file-based logger or STDERR
  class LineLogger < Logger
    
    def initialize( io = STDERR )
      super( ::Logger::Severity::DEBUG, StderrEmitter.new(io) )
    end
    
  end # LineLogger

end # Unilogger
