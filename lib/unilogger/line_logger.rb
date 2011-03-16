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
    
    # level methods may take 0, 1 or 2 arguments, or 0 arguments and a block.
    # argument 1 should be a string.
    # argument 2 should be a hash.
    # the block should yield a string
    Logger::Severity.constants.each do |const|
      # const e.g. INFO; label e.g. info; priority e.g. 1
      label = const.to_s.downcase.to_sym
      priority = Logger::Severity.const_get(const)
      define_method( label ) do |*args,&block|
        raise ArgumentError unless args.size <= 2 && ( ! block || args.empty? )
        message,options = *args
        raise ArgumentError if args.size == 2 and ( ! options.kind_of? Hash )
        if @level <= priority && ( args.size > 0 || block ) then
          if args.size == 2 then
            message = "#{message}; #{options.inspect}"
          elsif block then
            message = block.call()
          end
          self << "#{const} #{message}\n"
        end
        @level <= priority
      end
      # e.g. info?
      define_method( "#{label}?".to_sym ) do
        @level <= priority
      end
    end
    
  end # LineLogger

end # Unilogger
