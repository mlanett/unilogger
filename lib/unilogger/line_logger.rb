require "logger"

module Unilogger
  
  # Stringifies each log entry to a single line of text.
  # Writes to a traditional file-based logger or STDERR
  # Adds pid and timestamp to each log entry.
  # Implements IO API (<<) which bypasses levels.
  # Implements Logger API (debug, info, warn, error, fatal)
  class LineLogger
    
    include ::Logger::Severity
    attr_accessor :level
    
    # e.g. FileLogger.new( Logger.new("#{root}/log/#{env}.log") )
    def initialize( sink = STDERR )
      @sink = sink
      @level = DEBUG
    end
    
    def <<( message )
      @sink << "#{Time.now.to_i} [#{Process.pid}] #{message}"
    end
    
    # level methods may take 0, 1 or 2 arguments.
    # argument 1 should be a string.
    # argument 2 should be a hash.
    Logger::Severity.constants.each do |const|
      name  = const.to_s.downcase.to_sym
      prio = Logger::Severity.const_get(const)
      # e.g. info()
      define_method( name ) do |*args|
        raise ArgumentError if args.empty? or args.size > 2
        message,options = *args
        raise ArgumentError if args.size == 2 and ( ! options.kind_of? Hash )
        if @level <= prio then
          message = "#{message}; #{options.inspect}" if options
          self << "#{level} #{message}\n"
        end
        self
      end
      # e.g. info?
      define_method( "#{name}?".to_sym ) do
        @level <= prio
      end
    end
    
  end # LineLogger

end # Unilogger
